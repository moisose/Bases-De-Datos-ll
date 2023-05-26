import { useEffect } from "react";
import { Link } from "react-router-dom";
import classes from "./Details.module.css";
import { useState } from "react";
import { useLocation } from "react-router-dom";

import * as Constants from "../constants";

function Details() {
  const [artist, setArtist] = useState("");
  //   const [genres, setGenres] = useState("");
  const [songs, setSongs] = useState("");
  const [link, setLink] = useState("");
  const [songName, setSongName] = useState("");
  const [lyric, setLyric] = useState("");
  const [data, setData] = useState([]);
  const location = useLocation();

  // Get data passed by Link-State in SearchResult and converting the data object to string
  useEffect(() => {
    setLink(JSON.parse(location.state.info));
  }, [location]);

  // console.log("generos: " + data.artist);

  //Fetch to get the data need it to use in this .jsx
  useEffect(() => {
    const fetchData = async () => {
      try {
        if (link != "") {
          fetch(Constants.detailsLink + link.slice(1))
            .then((response) => response.json())
            .then((data) => {
              setData(data.data[0]);
            })
            .catch((error) => {
              console.log(error);
            });
        }
      } catch (error) {
        console.log(error);
      }
    };
    fetchData();
  }, [link]);

  return (
    <>
      {data ? (
        <>
          <ul className={classes.menu}>
            <li>
              <img
                className={classes.logo}
                src={Constants.detailsLogo}
                alt="logo"
              />
            </li>
            <li>
              <Link to={Constants.homeRoute} className={classes.back}>
                {/* <img
                className={classes.arrow}
                src={Constants.backImg}
                alt="back arrow"
              /> */}
                GO HOME
              </Link>
            </li>
          </ul>

          <div className={classes.container}>
            <h1 className={classes.artist}>{data.artist}</h1>
            <p className={classes.details}>
              <strong>
                {/* {Array.isArray(data.genres) && data.genres.join(" - ")} */}
                {data.genres}
              </strong>
            </p>
            <p className={classes.details}>
              <strong>{data.songs} Songs</strong>
            </p>
            <p className={classes.details}>
              <strong>Popularity:</strong> {data.popularity}
            </p>
            <p className={classes.details}>
              <strong>Link:</strong> {link}
            </p>
          </div>
          <h2>"{data.songName}"</h2>
          <div className={classes.column}>
            <span className={classes.lyric}>{data.lyric}</span>
          </div>
        </>
      ) : (
        <p>Loading...</p>
      )}
    </>
  );
}

export default Details;
