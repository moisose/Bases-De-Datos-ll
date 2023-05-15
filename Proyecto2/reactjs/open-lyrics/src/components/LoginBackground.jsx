import { Outlet } from "react-router-dom";

import classes from "./LoginBackground.module.css";

function LoginBackground() {
  return (
    <>
      <div className={classes.body}>
        <img className={classes.image} src="/openlyrics.png" alt="logo" />
      </div>
      <Outlet />
    </>
  );
}

export default LoginBackground;
