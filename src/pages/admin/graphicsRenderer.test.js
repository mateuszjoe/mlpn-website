import { subtitleForForm, titleForForm } from "./graphicsRenderer";

describe("graphics weekend headings", () => {
  const previewForm = {
    category: "round-preview",
    round: 12,
    previewScope: "weekend",
    previewWeekendStart: "2026-09-11",
    previewPage: 1,
    previewPageCount: 1,
  };

  test("labels a weekend preview by date rather than round", () => {
    expect(titleForForm(previewForm)).toBe("11–14.09");
    expect(subtitleForForm(previewForm)).toBe("Zapowiedź weekendu");
  });

  test("adds a page number only when a weekend preview has multiple pages", () => {
    expect(subtitleForForm({ ...previewForm, previewPage: 2, previewPageCount: 3 }))
      .toBe("Zapowiedź weekendu · 2/3");
    expect(subtitleForForm({ ...previewForm, previewPageCount: undefined }))
      .toBe("Zapowiedź weekendu");
  });

  test.each([
    ["2026-10-30", "30.10–02.11"],
    ["2027-12-31", "31.12–03.01"],
  ])("formats a weekend preview across a calendar boundary: %s", (friday, title) => {
    expect(titleForForm({ ...previewForm, previewWeekendStart: friday })).toBe(title);
  });

  test("shows a neutral weekend title until a valid Friday is selected", () => {
    expect(titleForForm({ ...previewForm, previewWeekendStart: "" })).toBe("Weekend");
    expect(titleForForm({ ...previewForm, previewWeekendStart: "2026-09-12" })).toBe("Weekend");
  });

  test.each(["round", undefined])("preserves round preview headings for scope %s", (previewScope) => {
    const form = { ...previewForm, previewScope, previewPage: 2, previewPageCount: 3 };
    expect(titleForForm(form)).toBe("XII kolejka");
    expect(subtitleForForm(form)).toBe("Zapowiedź");
  });

  test("preserves weekend and round result headings independently of preview state", () => {
    const form = {
      ...previewForm,
      category: "round-results",
      resultsScope: "weekend",
      weekendStart: "2026-09-04",
      resultsPage: 2,
      resultsPageCount: 4,
    };
    expect(titleForForm(form)).toBe("04–07.09");
    expect(subtitleForForm(form)).toBe("Wyniki weekendu · 2/4");
    expect(titleForForm({ ...form, resultsScope: "round" })).toBe("XII kolejka");
    expect(subtitleForForm({ ...form, resultsScope: "round" })).toBe("Wyniki");
  });

  test("preserves explicit title and subtitle overrides", () => {
    const form = { ...previewForm, title: "  Mecze MLPN  ", subtitle: "  Gramy razem  " };
    expect(titleForForm(form)).toBe("Mecze MLPN");
    expect(subtitleForForm(form)).toBe("Gramy razem");
  });
});
