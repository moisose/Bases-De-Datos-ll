import React, { useState } from "react";
import { FaSearch } from "react-icons/fa";
import classes from "./SearchBar.module.css";

export const SearchBar = ({ setResults }) => {
  const [input, setInput] = useState("");

  //TO SEND THE WORDS IN THE SEARCHBAR TO THE API (RIGHT NOW WDK IF WE SHOULD SEND IT AS A INDIVIDUAL WORDS OR LIKE AN COMPLETE STRING)
  const fetchData = (value) => {
    fetch("https://jsonplaceholder.typicode.com/users")
      .then((response) => response.json())
      .then((json) => {
        const results = json.filter((user) => {
          // Esta parte de filtrar deberia de ir en el backend (Nosotros deberiamos solo de pasar los datos y recibir lo necesario)
          return (
            value &&
            user &&
            user.name &&
            user.name.toLowerCase().includes(value)
          ); // El primero de value se utiliza para que no se muestre nada con la barra vacia
        }); //Filter goes to each element of the json file and take the propert we use in the function
        setResults(results);
      });
  };

  const handleChange = (value) => {
    setInput(value);
    fetchData(value);
  };

  return (
    <div className={classes.wrapper}>
      <FaSearch className={classes.icon} />
      <input
        className={classes.searchInput}
        placeholder="Search for Lyrics..."
        value={input}
        onChange={(e) => handleChange(e.target.value)}
      />
    </div>
  );
};
