import classes from "./SearchResultsList.module.css";
import { SearchResult } from "./SearchResult";

// list of all results, for each one a SearchResult is created
export const SearchResultsList = ({ results }) => {
  return (
    <div className={classes.resultsList}>
      {results.map((result, id) => {
        return <SearchResult result={result} key={id} />;
      })}
    </div>
  );
};

export default SearchResultsList;