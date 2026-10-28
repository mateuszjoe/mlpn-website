import React, { useId, useRef, useState } from "react";
import { CONTACT_LIMITS, createContactSubmissionId, getContactSubmissionError, normalizeContactFields, submitContactMessage, validateContactFields } from "../services/contactService";

const EMPTY_FORM = { name: "", email: "", subject: "", message: "", website: "" };

export default function ContactForm({ darkMode = false }) {
  const id = useId();
  const [fields, setFields] = useState(EMPTY_FORM);
  const [errors, setErrors] = useState({});
  const [state, setState] = useState("idle");
  const [error, setError] = useState("");
  const pending = useRef(false);
  const attempt = useRef(null);
  const formRef = useRef(null);
  const sending = state === "sending";
  const inputClass = `w-full px-4 py-2 rounded-lg border focus:outline-none focus:ring-2 focus:ring-green-500 ${darkMode ? "bg-white/5 border-white/10" : "bg-white border-gray-300"}`;

  const changeField = (event) => {
    const { name, value } = event.target;
    setFields((previous) => ({ ...previous, [name]: value }));
    setErrors((previous) => ({ ...previous, [name]: undefined }));
    setError("");
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    if (pending.current || state === "success") return;
    const invalid = validateContactFields(fields);
    setErrors(invalid);
    setError("");
    if (Object.keys(invalid).length) {
      if (invalid.website) setError(invalid.website);
      formRef.current?.elements.namedItem(Object.keys(invalid)[0])?.focus();
      return;
    }
    pending.current = true;
    setState("sending");
    try {
      const values = normalizeContactFields(fields);
      const signature = JSON.stringify(values);
      if (attempt.current?.signature !== signature) attempt.current = { signature, id: createContactSubmissionId() };
      await submitContactMessage(values, attempt.current.id);
      setState("success");
    } catch (cause) {
      setState("error");
      setError(getContactSubmissionError(cause));
    } finally {
      pending.current = false;
    }
  };

  const fieldProps = (name) => ({
    id: `${id}-${name}`,
    name,
    value: fields[name],
    onChange: changeField,
    required: true,
    maxLength: CONTACT_LIMITS[name],
    "aria-invalid": errors[name] ? true : undefined,
    "aria-describedby": errors[name] ? `${id}-${name}-error` : undefined,
    className: inputClass,
  });
  const fieldError = (name) => errors[name] && <p id={`${id}-${name}-error`} className={`mt-1 text-sm ${darkMode ? "text-red-300" : "text-red-700"}`}>{errors[name]}</p>;

  return (
    <div className={`p-6 rounded-2xl ${darkMode ? "bg-white/5" : "bg-white border border-gray-200"}`}>
      <h3 className="font-bold text-xl mb-4">Formularz kontaktowy</h3>
      <p className={`text-sm mb-5 ${darkMode ? "text-gray-300" : "text-gray-600"}`}>Wiadomość trafi do organizatorów MLPN. Podaj adres e-mail, pod którym możemy się z Tobą skontaktować.</p>
      {state === "success" ? (
        <div>
          <p role="status" className={`p-4 rounded-lg mb-4 ${darkMode ? "bg-green-500/15 text-green-300" : "bg-green-50 text-green-800"}`}>Wiadomość została przyjęta i jest dostępna w skrzynce organizatorów MLPN.</p>
          <button type="button" className="px-4 py-2 rounded-lg font-bold bg-green-600 text-white hover:bg-green-700 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-green-500" onClick={() => { setFields(EMPTY_FORM); setErrors({}); setError(""); attempt.current = null; setState("idle"); }}>Napisz kolejną wiadomość</button>
        </div>
      ) : (
        <form ref={formRef} onSubmit={handleSubmit} noValidate aria-busy={sending}>
          <fieldset disabled={sending} className="space-y-4 min-w-0">
            <legend className="sr-only">Twoje dane i wiadomość (wszystkie pola wymagane)</legend>
            <div><label htmlFor={`${id}-name`} className="block text-sm font-bold mb-2">Imię i nazwisko</label><input {...fieldProps("name")} autoComplete="name" minLength={2} />{fieldError("name")}</div>
            <div><label htmlFor={`${id}-email`} className="block text-sm font-bold mb-2">Adres e-mail</label><input {...fieldProps("email")} type="email" autoComplete="email" />{fieldError("email")}</div>
            <div><label htmlFor={`${id}-subject`} className="block text-sm font-bold mb-2">Temat</label><input {...fieldProps("subject")} minLength={3} />{fieldError("subject")}</div>
            <div><label htmlFor={`${id}-message`} className="block text-sm font-bold mb-2">Wiadomość</label><textarea {...fieldProps("message")} minLength={10} rows={6} className={`${inputClass} resize-y`} />{fieldError("message")}</div>
            <div aria-hidden="true" style={{ position: "absolute", width: 1, height: 1, overflow: "hidden", clipPath: "inset(50%)" }}><label htmlFor={`${id}-website`}>Strona internetowa — pozostaw puste</label><input id={`${id}-website`} name="website" value={fields.website} onChange={changeField} autoComplete="off" tabIndex={-1} /></div>
            <button type="submit" className="w-full px-6 py-3 rounded-lg font-bold bg-green-600 text-white hover:bg-green-700 disabled:opacity-60 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-green-500">{sending ? "Wysyłanie…" : state === "error" ? "Spróbuj wysłać ponownie" : "Wyślij wiadomość"}</button>
          </fieldset>
          {sending && <p role="status" className="text-sm mt-3">Trwa przekazywanie wiadomości…</p>}
          {error && <p role="alert" className={`text-sm mt-3 p-3 rounded-lg ${darkMode ? "bg-red-500/10 text-red-300" : "bg-red-50 text-red-700"}`}>{error}</p>}
          {Object.keys(errors).some((key) => errors[key] && key !== "website") && <p role="alert" className="sr-only">Popraw zaznaczone pola formularza.</p>}
        </form>
      )}
    </div>
  );
}
