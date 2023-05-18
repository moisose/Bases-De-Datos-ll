import React from "react";
import classes from "./SearchResult.module.css";

export const SearchResult = ({ result }) => {
  return <div className={classes.searchResult}>{result.name}</div>;
};

export default SearchResult;
