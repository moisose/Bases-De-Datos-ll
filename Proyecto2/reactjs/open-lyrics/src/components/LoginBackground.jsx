import { Outlet } from "react-router-dom";

import classes from "./LoginBackground.module.css";
import * as Constants from "../constants";

function LoginBackground() {
  return (
    <>
      <div className={classes.body}>
        <img className={classes.image} src={Constants.loginLogo} alt="logo" />
      </div>
      <Outlet />
    </>
  );
}

export default LoginBackground;


