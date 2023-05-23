import React, { useEffect, useState } from "react";
import { FaSearch } from "react-icons/fa";
import classes from "./SearchBar.module.css";
import { debounce } from "lodash";

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
}) => {
  const [inputSearch, setInputSearch] = useState("");
  const debounceValue = useDebounce(inputSearch, 650);

  // const useDebounce = (value, delay) => {
  //   const [debounceValue, setDebounceValue] = useState(value);

  //   useEffect(() => {
  //     const handler = setTimeout(() => {
  //       setDebounceValue(value);
  //     }, delay);

  //     return () => {
  //       clearTimeout(handler);
  //     };
  //   }, [value, delay]);

  //   return debounceValue;
  // };

  // this useEffect is responsible for calling the api to request
  // the results every time something is written in the search bar
  // or when an element of the facets is marked or modified
  useEffect(() => {
    console.log("use effect");
    console.log(valuesSongs);
    console.log(valuesPopularity);
    setInput(inputSearch);

    const getData = async () => {
      if (inputSearch === "") {
        setResults([]);
        return;
      } else {
        fetch(Constants.searchBarLink + inputSearch)
          .then((response) => response.json())
          .then((data) => {
            // console.log("data es" + data);
            const formattedResults = data.data.map((item) => {
              return {
                name: item.songName,
                artist: item.artist,
                link: item.songLink,
                fragment: item.lyric,
              };
            });
            setResults(formattedResults);
          })
          .catch((error) => {
            console.log("Error getting the data:", error);
          });
      }
    };

    inputSearch ? getData() : setResults([]);
  }, [
    setInput,
    artists,
    languages,
    genres,
    setResults,
    valuesPopularity,
    valuesSongs,
    debounceValue,
  ]);

  // //TO SEND THE WORDS IN THE SEARCHBAR TO THE API (RIGHT NOW WDK IF WE SHOULD SEND IT AS A INDIVIDUAL WORDS OR LIKE AN COMPLETE STRING)
  // const fetchData = (value) => {
  //   console.log(facets);
  //   fetch("https://jsonplaceholder.typicode.com/users")
  //     .then((response) => response.json())
  //     .then((json) => {
  //       const results = json.filter((user) => {
  //         // Esta parte de filtrar deberia de ir en el backend (Nosotros deberiamos solo de pasar los datos y recibir lo necesario)
  //         return (
  //           value &&
  //           user &&
  //           user.name &&
  //           user.name.toLowerCase().includes(value)
  //         ); // El primero de value se utiliza para que no se muestre nada con la barra vacia
  //       }); //Filter goes to each element of the json file and take the propert we use in the function
  //       setResults(results);
  //       console.log("facets en search: ", facets);
  //     });
  // };

  // console.log("facets en search: ", facets);

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
