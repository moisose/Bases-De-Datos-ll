import React, { useEffect } from "react";
import { useState } from "react";
import classes from "./SearchResult.module.css";
import { json, useNavigate } from "react-router-dom";
import { Link } from "react-router-dom";


// each of the results is handled within a
// box with the information of the letter found
export const SearchResult = ({ result }) => {
  const [lyric, setLyric] = useState("");
  const navigate = useNavigate();

  useEffect(() => {
    setLyric(result.fragment);
    const regex = /\\n|\\r\\n|\\n\\r|\\r/g;
    lyric.replace(regex, "<br>");
  }, [lyric]);

  return <div className={classes.searchResult}>
    <div className={classes.name}>{result.name}</div>
    <div className={classes.artist}>{result.artist}</div>
    <div className={classes.songFragment}>{lyric}</div>
    <Link to="/details" state={{ info: JSON.stringify(result.link)}}
      className={classes.button} >
      Show details
    </Link>
    </div>;
};

export default {
  SearchResult
}
