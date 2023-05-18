import React, { useState, useEffect } from "react";
import classes from "../routes/Home.module.css";

const MyComponent = ({
  apiLink,
  list,
  setList,
  selected,
  setSelected,
  prefix,
}) => {
  useEffect(() => {
    fetch(apiLink)
      .then((response) => response.json())
      .then((data) => {
        if (Array.isArray(data.entries)) {
          setList(data.entries);
        }
      })
      .catch((error) => {
        console.log("Error getting the data:", error);
      });
  }, []);

  const handleChange = (e, index) => {
    const activeData = document.getElementById(index).checked;
    if (activeData) {
      setSelected((oldData) => [...oldData, e.target.value]);
    } else {
      setSelected(selected.filter((values) => values !== e.target.value));
    }
  };

  console.log("Selected: " + selected);

  return (
    <div className={classes.checkbox}>
      {list.map((item, i) => (
        <div className={classes.individualCheck} key={item.API + { prefix }}>
          <input
            className={classes.checkbutton}
            id={item.API + { prefix }}
            type="checkbox"
            value={item.API}
            checked={selected.includes(item.API)}
            onChange={(e) => handleChange(e, item.API + { prefix })}
          />
          <span>{item.API}</span>
        </div>
      ))}
    </div>
  );
};

export default MyComponent;
