import { useEffect, useState } from "react";
import { FaSearch } from "react-icons/fa";
import classes from "./SearchBar.module.css";

import { useDebounce } from "./useDebounce";

import * as Constants from "../constants";

// search bar in which the call to the api
// to request the lyrics of songs is handled
export const SearchBar = ({
  setInput,
  artists,
  languages,
  genres,
  setResults,
  valuesPopularity,
  valuesSongs,
  setCurrentPage,
}) => {
  const [inputSearch, setInputSearch] = useState("");
  const debounceValue = useDebounce(inputSearch, 300);

  // this useEffect is responsible for calling the api to request
  // the results every time something is written in the search bar
  // or when an element of the facets is marked or modified
  useEffect(() => {
    const artistsParam = artists.length > 0 ? artists : null;
    const languagesParam = languages.length > 0 ? languages : null;
    const genresParam = genres.length > 0 ? genres : null;

    setInput(inputSearch);
    setCurrentPage(1);

    const getData = async () => {
      if (inputSearch === "") {
        setResults([]);
        return;
      } else {
        fetch(
          Constants.searchBarLink +
            inputSearch +
            "/" +
            artistsParam +
            "/" +
            languagesParam +
            "/" +
            genresParam +
            "/" +
            valuesPopularity[0] +
            "/" +
            valuesPopularity[1] +
            "/" +
            "-1"
        )
          .then((response) => response.json())
          .then((data) => {
            // console.log("data es" + data);
            const formattedResults = data.data.map((item) => {
              return {
                name: item.songName,
                artist: item.artist,
                link: item.songLink,
                fragment: item.lyric,
                highlights: item.highlights,
              };
            });

            // console.log("formated results: " + formattedResults.length);
            setResults(formattedResults);
          })
          .catch((error) => {
            console.log("Error getting the data:", error);
          });
      }
    };

    inputSearch ? getData() : setResults([]);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [
    setInput,
    artists,
    languages,
    genres,
    setResults,
    valuesPopularity,
    // valuesSongs,
    debounceValue,
  ]);

  // handle character typing
  const handleChange = (value) => {
    setInputSearch(value);
    // fetchData(value);
  };

  return (
    <div className={classes.wrapper}>
      <FaSearch className={classes.icon} />
      <input
        className={classes.searchInput}
        placeholder="Search for Lyrics..."
        value={inputSearch}
        onChange={(e) => handleChange(e.target.value)}
      />
    </div>
  );
};
