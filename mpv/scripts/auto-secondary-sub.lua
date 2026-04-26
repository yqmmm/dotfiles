local mp = require("mp")

local function lower(value)
  if type(value) ~= "string" then
    return ""
  end
  return value:lower()
end

local function normalize_words(value)
  return " " .. lower(value):gsub("[^%w%-_]+", " ") .. " "
end

local function has_any(haystack, needles)
  for _, needle in ipairs(needles) do
    if haystack:find(needle, 1, true) then
      return true
    end
  end
  return false
end

local primary_langs = { "ja", "jpn", "japanese" }
local zh_langs = {
  "zh",
  "zh-cn",
  "zh-hans",
  "chi",
  "zho",
  "chs",
  "cn",
  "chinese",
}
local zh_title_markers = {
  " chinese ",
  " mandarin ",
  " zh ",
  " zh-cn ",
  " zh-hans ",
  " chs ",
  " 简",
}
local zh_hans_markers = {
  " simplified ",
  " gb ",
  " chs ",
  " zh-cn ",
  " zh-hans ",
  "简",
  "简体",
}
local zh_hant_markers = {
  " traditional ",
  " cht ",
  " zh-tw ",
  " zh-hant ",
  "繁",
  "繁體",
  "繁体",
}

local function is_sub_track(track)
  return track
    and track.type == "sub"
    and track.id ~= nil
    and not track["external-forced"]
end

local function score_primary(track)
  local lang = lower(track.lang)
  local title = normalize_words(track.title)

  if has_any(lang, primary_langs) then
    return 3
  end
  if has_any(title, primary_langs) then
    return 2
  end
  return 0
end

local function score_secondary(track)
  local lang = lower(track.lang)
  local title = normalize_words(track.title)

  if not has_any(lang, zh_langs) and not has_any(title, zh_title_markers) then
    return 0
  end
  if has_any(lang, zh_hant_markers) or has_any(title, zh_hant_markers) then
    return 1
  end
  if has_any(lang, zh_hans_markers) or has_any(title, zh_hans_markers) then
    return 3
  end
  return 2
end

local function select_subtitles()
  local tracks = mp.get_property_native("track-list") or {}
  local primary
  local secondary
  local primary_score = 0
  local secondary_score = 0

  for _, track in ipairs(tracks) do
    if is_sub_track(track) then
      local current_primary_score = score_primary(track)
      if current_primary_score > primary_score then
        primary = track
        primary_score = current_primary_score
      end

      local current_secondary_score = score_secondary(track)
      if current_secondary_score > secondary_score then
        secondary = track
        secondary_score = current_secondary_score
      end
    end
  end

  if primary then
    mp.set_property_number("sid", primary.id)
  end

  if secondary and (not primary or secondary.id ~= primary.id) then
    mp.set_property_number("secondary-sid", secondary.id)
  else
    mp.set_property("secondary-sid", "no")
  end
end

mp.register_event("file-loaded", select_subtitles)
