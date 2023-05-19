import React from "react";
import ReactDOM from "react-dom/client";
import { RouterProvider, createBrowserRouter } from "react-router-dom";

import * as Constants from "./constants";
import Login from "./routes/Login.jsx";
import LoginBg from "./components/LoginBackground.jsx";
import Home from "./routes/Home.jsx";
import Details from "./routes/Details.jsx";
import "./index.css";

// web page routes
// routes of the web page, there are 4. Login, create user, home and details
const router = createBrowserRouter([
  {
    path: Constants.loginRoute,
    element: <LoginBg />,
    children: [
      {
        path: Constants.createUserRoute,
        element: <Login />,
      },
    ],
  },
  {
    path: Constants.homeRoute,
    element: <Home />,
  },
  {
    path: Constants.detailsRoute,
    element: <Details />,
  },
]);

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>
);
