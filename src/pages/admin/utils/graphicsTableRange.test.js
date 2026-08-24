import {
  getTablePositionOptions,
  getTablePositions,
  isTableRowDimmed,
  resolveTableRange,
} from "./graphicsTableRange";

describe("graphics table range", () => {
  test("uses the real standings positions, including gaps", () => {
    const standings = [{ position: 1 }, { position: 2 }, { position: 4 }];

    expect(getTablePositions(standings)).toEqual([1, 2, 4]);
    expect(getTablePositionOptions(standings)).toEqual([
      { value: "1", label: "Poz. 1" },
      { value: "2", label: "Poz. 2" },
      { value: "4", label: "Poz. 4" },
    ]);
  });

  test("dims only rows outside an enabled inclusive range", () => {
    const range = resolveTableRange(
      { enabled: true, from: "3", to: "7" },
      Array.from({ length: 11 }, (_, index) => index + 1)
    );

    expect(range).toMatchObject({ active: true, from: 3, to: 7 });
    expect(isTableRowDimmed(range, 2)).toBe(true);
    expect(isTableRowDimmed(range, 3)).toBe(false);
    expect(isTableRowDimmed(range, 7)).toBe(false);
    expect(isTableRowDimmed(range, 8)).toBe(true);
  });

  test("keeps disabled and full-table ranges inactive", () => {
    const positions = Array.from({ length: 11 }, (_, index) => index + 1);

    expect(resolveTableRange({ enabled: false, from: 3, to: 7 }, positions).active).toBe(false);
    expect(resolveTableRange({ enabled: true, from: 1, to: 11 }, positions).active).toBe(false);
  });

  test("repairs inverted and out-of-bounds ranges deterministically", () => {
    const positions = Array.from({ length: 10 }, (_, index) => index + 1);

    expect(resolveTableRange({ enabled: true, from: 8, to: 5 }, positions)).toMatchObject({
      active: true,
      from: 8,
      to: 8,
    });
    expect(resolveTableRange({ enabled: true, from: 11, to: 14 }, positions)).toMatchObject({
      active: true,
      from: 10,
      to: 10,
    });
  });
});
