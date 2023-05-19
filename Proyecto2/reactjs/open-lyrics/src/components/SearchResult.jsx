import React from "react";
import classes from "./SearchResult.module.css";

// each of the results is handled within a
// box with the information of the letter found
export const SearchResult = ({ result }) => {
  return <div className={classes.searchResult}>{result.name}</div>;
};

export default SearchResult;
