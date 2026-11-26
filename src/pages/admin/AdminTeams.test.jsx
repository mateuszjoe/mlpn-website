import React from "react";
import { createRoot } from "react-dom/client";
import { act } from "react-dom/test-utils";
import AdminTeams from "./AdminTeams";
import { supabase } from "../../lib/supabase";

jest.mock("../../lib/supabase", () => ({
  supabase: { from: jest.fn(), storage: { from: jest.fn() } },
}));

let host, root, teams, upload, writes, originalImage;
const oldPhoto = "https://example.test/team-old.webp";
const newPhoto = "https://example.test/team-new.webp";

function query() {
  let payload, id, inserting;
  const builder = {
    select: () => builder,
    order: async () => ({ data: teams }),
    update: (value) => { payload = value; return builder; },
    insert: (value) => { payload = value; inserting = true; return builder; },
    eq: (key, value) => { id = value; return builder; },
    single: async () => {
      writes.push(payload);
      const row = inserting ? { id: "new-team", ...payload } : teams.find((team) => team.id === id);
      if (inserting) teams.push(row);
      else Object.assign(row, payload);
      return { data: row, error: null };
    },
  };
  return builder;
}

async function click(text) {
  const button = [...host.querySelectorAll("button")].find((node) => node.textContent.trim() === text);
  expect(button).toBeDefined();
  await act(async () => { button.click(); });
}

async function edit() {
  await act(async () => { host.querySelector('button[title="Edytuj"]').click(); });
}

async function choosePhoto(size) {
  const input = host.querySelector('input[aria-label="Zdjęcie drużyny"]');
  const file = new File(["photo"], "druzyna.jpg", { type: "image/jpeg" });
  if (size) Object.defineProperty(file, "size", { value: size });
  Object.defineProperty(input, "files", { configurable: true, value: [file] });
  await act(async () => { input.dispatchEvent(new Event("change", { bubbles: true })); });
}

beforeEach(async () => {
  global.IS_REACT_ACT_ENVIRONMENT = true;
  host = document.createElement("div");
  document.body.appendChild(host);
  root = createRoot(host);
  writes = [];
  teams = [{ id: "team", name: "Drużyna testowa", abbreviation: "TES", logo_url: "https://example.test/logo.webp", team_photo_url: oldPhoto, is_active: true }];
  supabase.from.mockReset().mockImplementation(query);
  upload = jest.fn().mockResolvedValue({ error: null });
  supabase.storage.from.mockReset().mockReturnValue({
    upload,
    getPublicUrl: () => ({ data: { publicUrl: newPhoto } }),
  });
  originalImage = window.Image;
  window.Image = class {
    naturalWidth = 2400;
    naturalHeight = 1600;
    set src(value) { Promise.resolve().then(() => this.onload()); }
  };
  URL.createObjectURL = jest.fn(() => "blob:test-photo");
  URL.revokeObjectURL = jest.fn();
  jest.spyOn(HTMLCanvasElement.prototype, "getContext").mockReturnValue({ clearRect: jest.fn(), drawImage: jest.fn() });
  jest.spyOn(HTMLCanvasElement.prototype, "toBlob").mockImplementation(function (callback) {
    expect(this.width).toBe(1920);
    expect(this.height).toBe(1280);
    callback(new Blob(["compressed-photo"], { type: "image/webp" }));
  });
  await act(async () => { root.render(<AdminTeams darkMode={false} />); });
});

afterEach(async () => {
  await act(async () => { root.unmount(); });
  host.remove();
  window.Image = originalImage;
  jest.restoreAllMocks();
});

test("editing and saving other fields preserves the existing team photo and logo", async () => {
  await edit();
  expect(host.querySelector('img[alt="Zdjęcie drużyny"]').src).toBe(oldPhoto);
  await click("Zapisz");
  expect(writes[0].team_photo_url).toBe(oldPhoto);
  expect(writes[0].logo_url).toBe("https://example.test/logo.webp");
});

test("uploads a resized group photo and retains it after saving and reopening", async () => {
  await edit();
  await choosePhoto();
  expect(supabase.storage.from).toHaveBeenCalledWith("team-logos");
  expect(upload).toHaveBeenCalledWith(expect.stringMatching(/^team-photos\/.+\.webp$/), expect.any(File), expect.objectContaining({ contentType: "image/webp" }));
  expect(host.querySelector('img[alt="Zdjęcie drużyny"]').src).toBe(newPhoto);
  expect(writes).toHaveLength(0);
  await click("Zapisz");
  await edit();
  expect(host.querySelector('img[alt="Zdjęcie drużyny"]').src).toBe(newPhoto);
  expect(teams[0].logo_url).toBe("https://example.test/logo.webp");
});

test("removal is applied only when the form is saved", async () => {
  await edit();
  await click("Usuń zdjęcie");
  await click("Anuluj");
  await edit();
  expect(host.querySelector('img[alt="Zdjęcie drużyny"]').src).toBe(oldPhoto);
  await click("Usuń zdjęcie");
  await click("Zapisz");
  expect(teams[0].team_photo_url).toBeNull();
});

test("a failed upload leaves the current photo intact and displays an error", async () => {
  upload.mockResolvedValue({ error: { message: "Brak połączenia" } });
  await edit();
  await choosePhoto();
  expect(host.textContent).toContain("Brak połączenia");
  expect(host.querySelector('img[alt="Zdjęcie drużyny"]').src).toBe(oldPhoto);
  await click("Zapisz");
  expect(teams[0].team_photo_url).toBe(oldPhoto);
});

test("saving and closing are blocked until the upload completes", async () => {
  let finishUpload;
  upload.mockImplementation(() => new Promise((resolve) => { finishUpload = resolve; }));
  await edit();
  await choosePhoto();
  expect(host.querySelector('button[type="submit"]').disabled).toBe(true);
  await act(async () => { host.querySelector("form").dispatchEvent(new Event("submit", { bubbles: true, cancelable: true })); });
  await click("Anuluj");
  expect(writes).toHaveLength(0);
  expect(host.querySelector("form")).not.toBeNull();
  await act(async () => { finishUpload({ error: null }); });
  expect(host.querySelector('button[type="submit"]').disabled).toBe(false);
  await click("Zapisz");
  expect(teams[0].team_photo_url).toBe(newPhoto);
});

test("rejects oversized files without uploading or losing the existing photo", async () => {
  await edit();
  await choosePhoto(8 * 1024 * 1024 + 1);
  expect(host.textContent).toContain("max 8MB");
  expect(upload).not.toHaveBeenCalled();
  expect(host.querySelector('img[alt="Zdjęcie drużyny"]').src).toBe(oldPhoto);
  expect(host.querySelector('button[type="submit"]').disabled).toBe(false);
});

test("a new team form does not inherit the previously edited team's photo", async () => {
  await edit();
  await click("Anuluj");
  await click("Dodaj drużynę");
  expect(host.querySelector('img[alt="Zdjęcie drużyny"]')).toBeNull();
  await choosePhoto();
  await act(async () => { host.querySelector("form").dispatchEvent(new Event("submit", { bubbles: true, cancelable: true })); });
  expect(writes[0].team_photo_url).toBe(newPhoto);
});
