import React from "react";

export default function AdminFormField({
  label, name, type = "text", value, onChange,
  options, required, darkMode, placeholder, helpText,
  disabled, min, max, step
}) {
  const inputClass = darkMode
    ? "bg-white/5 border-white/10 text-white placeholder-gray-500 focus:border-blue-500"
    : "bg-white border-gray-300 text-gray-900 placeholder-gray-400 focus:border-blue-500";
  const labelClass = darkMode ? "text-gray-300" : "text-gray-700";
  const base = `w-full px-3 py-2 rounded-xl border outline-none transition-colors ${inputClass}`;

  const optionStyle = darkMode ? { backgroundColor: "#1a1f2e", color: "#fff" } : {};

  if (type === "select") {
    return (
      <div className="space-y-1">
        <label className={`block text-sm font-medium ${labelClass}`}>{label}{required && <span className="text-red-400 ml-1">*</span>}</label>
        <select name={name} value={value} onChange={onChange} required={required} disabled={disabled} className={base}>
          <option value="" style={optionStyle}>Wybierz...</option>
          {options?.map(o => (
            <option key={o.value} value={o.value} style={optionStyle}>{o.label}</option>
          ))}
        </select>
      </div>
    );
  }

  if (type === "textarea") {
    return (
      <div className="space-y-1">
        <label className={`block text-sm font-medium ${labelClass}`}>{label}{required && <span className="text-red-400 ml-1">*</span>}</label>
        <textarea
          name={name} value={value} onChange={onChange} required={required}
          placeholder={placeholder} disabled={disabled} rows={4}
          className={base}
        />
        {helpText && <p className="text-xs text-gray-400">{helpText}</p>}
      </div>
    );
  }

  if (type === "checkbox") {
    return (
      <label className={`flex items-center gap-2 cursor-pointer ${labelClass}`}>
        <input
          type="checkbox" name={name} checked={!!value}
          onChange={(e) => onChange({ target: { name, value: e.target.checked } })}
          disabled={disabled}
          className="w-4 h-4 rounded border-gray-300"
        />
        <span className="text-sm font-medium">{label}</span>
      </label>
    );
  }

  return (
    <div className="space-y-1">
      <label className={`block text-sm font-medium ${labelClass}`}>{label}{required && <span className="text-red-400 ml-1">*</span>}</label>
      <input
        type={type} name={name} value={value ?? ""} onChange={onChange}
        required={required} placeholder={placeholder} disabled={disabled}
        min={min} max={max} step={step}
        className={base}
      />
      {helpText && <p className="text-xs text-gray-400">{helpText}</p>}
    </div>
  );
}
