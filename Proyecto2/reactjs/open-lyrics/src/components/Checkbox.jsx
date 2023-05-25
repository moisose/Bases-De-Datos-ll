/* eslint-disable react/prop-types */
import classes from "./Checkbox.module.css";

// receives the list of the facet, the list of selected
// elements of the facet, its set and the prefix to differentiate the ids
const Checkbox = ({ list, setList, selected, setSelected, prefix }) => {
  const handleChange = (e, index) => {
    const activeData = document.getElementById(index).checked;
    console.log(document.getElementById(index));
    if (activeData) {
      setSelected((oldData) => [...oldData, e.target.value]);
    } else {
      setSelected(selected.filter((values) => values !== e.target.value));
    }
  };

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
