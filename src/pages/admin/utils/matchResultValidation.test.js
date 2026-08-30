import { getWalkoverDirectionError } from "./matchResultValidation";

describe("walkover direction validation", () => {
  test("accepts a home walkover when the home score is higher", () => {
    expect(getWalkoverDirectionError("walkover_home", 3, 0)).toBeNull();
    expect(getWalkoverDirectionError("walkover_home", 8, 0)).toBeNull();
  });

  test("accepts an away walkover when the away score is higher", () => {
    expect(getWalkoverDirectionError("walkover_away", 0, 3)).toBeNull();
    expect(getWalkoverDirectionError("walkover_away", 1, 4)).toBeNull();
  });

  test("rejects a walkover pointing at the losing side", () => {
    expect(getWalkoverDirectionError("walkover_home", 0, 3)).toContain("gosci");
    expect(getWalkoverDirectionError("walkover_away", 3, 0)).toContain("gospodarzy");
  });

  test("rejects draws and missing scores for a walkover", () => {
    expect(getWalkoverDirectionError("walkover_home", 3, 3)).toContain("remisem");
    expect(getWalkoverDirectionError("walkover_away", null, 3)).toContain("wyniku obu");
  });

  test("does not validate non-walkover statuses", () => {
    expect(getWalkoverDirectionError("completed", 0, 3)).toBeNull();
    expect(getWalkoverDirectionError("scheduled", null, null)).toBeNull();
  });
});
