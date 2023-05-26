import { useEffect } from "react";
import { useState } from "react";
import classes from "./SearchResult.module.css";
import { useNavigate } from "react-router-dom";
import { Link } from "react-router-dom";

// each of the results is handled within a
// box with the information of the letter found
export const SearchResult = ({ result }) => {
  const [lyric, setLyric] = useState("");
  const navigate = useNavigate();

  useEffect(() => {
    if (result) {
      const regex = /\\n|\\r\\n|\\n\\r|\\r/g;
      let formattedLyric = result.fragment.replace(regex, "<br>");

      const hitValues = result.highlights
        .filter((item) => item.type === "hit")
        .map((item) => item.value);

      const replaceFn = (match) => `<strong>${match}</strong>`;

      formattedLyric = formattedLyric.replace(
        new RegExp(`\\b(${hitValues.join("|")})\\b`, "gi"),
        replaceFn
      );

      setLyric(formattedLyric);
    }
  }, [result]);

  // console.log("highlights: " + hits);

  // for (const hit of hits) {
  //   console.log(hit.value);
  // }

  // console.log("largo: " + hits.length);

  // console.log("letra: " + lyric);

  return (
    <div className={classes.searchResult}>
      <div className={classes.name}>{result.name}</div>
      <div className={classes.artist}>{result.artist}</div>
      <div className={classes.songFragment}>
        <div
          className={classes.lyric}
          dangerouslySetInnerHTML={{ __html: lyric }}
        />
      </div>
      <Link
        to="/details"
        state={{ info: JSON.stringify(result.link) }}
        className={classes.button}
      >
        Show details
      </Link>
    </div>
  );
};

export default {
  SearchResult,
};
