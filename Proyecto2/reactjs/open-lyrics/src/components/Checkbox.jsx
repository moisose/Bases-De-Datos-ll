import React, { useState, useEffect } from "react";
import classes from "./Checkbox.module.css";
import * as Constants from "../constants";

// receives the list of the facet, the list of selected
// elements of the facet, its set and the prefix to differentiate the ids
const Checkbox = ({
  apiLink,
  list,
  setList,
  selected,
  setSelected,
  prefix,
}) => {
  //   useEffect(() => {
  //     fetch(apiLink)
  //       .then((response) => response.json())
  //       .then((data) => {
  //         if (Array.isArray(data.entries)) {
  //           setList(data.entries);
  //         }
  //       })
  //       .catch((error) => {
  //         console.log("Error getting the data:", error);
  //       });
  //   }, []);

  // useEffect(() => {
  //   fetch("https://api.openbrewerydb.org/v1/breweries") // Reemplaza la URL con tu endpoint de API
  //     .then((response) => response.json())
  //     .then((data) => setList(data))
  //     .catch((error) => console.log("Error getting the data:", error));
  // }, []);

  const handleChange = (e, index) => {
    const activeData = document.getElementById(index).checked;
    console.log(document.getElementById(index));
    if (activeData) {
      setSelected((oldData) => [...oldData, e.target.value]);
    } else {
      setSelected(selected.filter((values) => values !== e.target.value));
    }
  };

  // console.log("Selected: " + selected);

  return (
    <div className={classes.checkbox}>
      {list.map((item, i) => (
        <div className={classes.individualCheck} key={i}>
          <input
            className={classes.checkbutton}
            id={item.name + prefix}
            type="checkbox"
            value={item.name}
            checked={selected.includes(item.name)}
            onChange={(e) => handleChange(e, item.name + prefix)}
          />
          <span>{item.name}</span>
        </div>
      ))}
    </div>
  );
};

export default Checkbox;
