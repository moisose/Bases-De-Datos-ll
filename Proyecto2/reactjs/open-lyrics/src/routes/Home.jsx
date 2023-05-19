import React, { useCallback, useEffect } from "react";
import { Link } from "react-router-dom";
// import { firebaseProperties } from "../fb";

import Slider from "react-slider";
import { useState } from "react";

import * as Constants from "../constants";

import classes from "./Home.module.css";
import Checkbox from "../components/Checkbox";
import { SearchBar } from "../components/SearchBar";
import { SearchResultsList } from "../components/SearchResultsList";
import Pagination from "../components/Pagination";

const Home = () => {
  // const for the sliders
  // --------------------------------------------------------------------
  const [minPopularity, setMinPopularity] = useState(0);
  const [maxPopularity, setMaxPopularity] = useState(100);
  const [valuesPopularity, setValuesPopularity] = useState([
    minPopularity,
    maxPopularity,
  ]);

  // const [minSongs, setMinSongs] = useState(0);
  const [maxSongs, setMaxSongs] = useState(52438941);
  const [valuesSongs, setValuesSongs] = useState(maxSongs);
  // --------------------------------------------------------------------

  // const For the checkboxes
  // --------------------------------------------------------------------
  const [artistsFacet, setArtistsFacet] = useState([]);
  const [selectedArtists, setSelectedArtists] = useState([]);

  const [languagesFacet, setLanguagesFacet] = useState([]);
  const [selectedLanguages, setSelectedLanguages] = useState([]);

  const [genresFacet, setGenresFacet] = useState([]);
  const [selectedGenres, setSelectedGenres] = useState([]);
  // --------------------------------------------------------------------

  // this prefixes differentiate the different checkboxes ids
  // --------------------------------------------------------------------
  const prefixes = ["1", "2", "3"];
  // --------------------------------------------------------------------

  //Pagination
  // --------------------------------------------------------------------
  const [results, setResults] = useState([]);
  // const setResultsCallback = useCallback((newResults) => {
  //   setResults(newResults);
  // }, []);
  const [currentPage, setCurrentPage] = useState(1);
  const [postsPerPage, setPostsPerPage] = useState(8);
  const lastPostIndex = currentPage * postsPerPage;
  const firstPostIndex = lastPostIndex - postsPerPage;
  const currentPosts = results.slice(firstPostIndex, lastPostIndex);
  // --------------------------------------------------------------------

  // this handle the reset filters button
  // clear the selected lists
  const handleCheckAllChange = (e) => {
    setSelectedArtists([]);
    setSelectedLanguages([]);
    setSelectedGenres([]);
    setValuesPopularity([0, 100]);
  };

  // load all the data from the api to the facets
  useEffect(() => {
    fetch(Constants.facetsApiLink)
      .then((response) => response.json())
      .then((data) => {
        if (
          Array.isArray(data.artists) &&
          Array.isArray(data.languages) &&
          Array.isArray(data.genres)
        ) {
          setArtistsFacet(data.artists);
          setLanguagesFacet(data.languages);
          setGenresFacet(data.genres);
        }
      })
      .catch((error) => {
        console.log("Error getting the data:", error);
      });
  }, []);

  //update song slider range
  useEffect(() => {
    setMaxSongs(results.length);
    setValuesSongs(maxSongs);
  }, [results, maxSongs]);

  // console.log(valuesSongs);

  // load the facets data into the facets lists
  // --------------------------------------------------------------------
  // useEffect(() => {
  //   fetch("https://mocki.io/v1/ce166011-9b6a-41f4-b284-787500876c7e") // Reemplaza la URL con tu endpoint de API
  //     .then((response) => response.json())
  //     .then((data) => {
  //       setArtistsFacet(data), setLanguagesFacet(data), setGenresFacet(data);
  //     })
  //     .catch((error) => console.log("Error getting the data:", error));
  // }, []);

  // console.log("use effeeeeect");
  // --------------------------------------------------------------------

  return (
    // main container
    // --------------------------------------------------------------------
    <div className={classes.container}>
      {/* container for the logo and the logout link */}
      <div className={classes.logo}>
        <img className={classes.image} src={Constants.homeLogo} alt="logo" />
        <Link to={Constants.loginRoute} className={classes.logout}>
          Log out
        </Link>
      </div>
      {/* -------------------------------------------------------------------- */}
      {/* search bar container */}
      <div className={classes.header}>
        <div className={classes.searchContainer}>
          <SearchBar
            artists={selectedArtists}
            languages={selectedLanguages}
            genres={selectedGenres}
            setResults={setResults}
            valuesSongs={valuesSongs}
            valuesPopularity={valuesPopularity}
          />
        </div>
      </div>
      {/* reset filter button container */}
      {/* -------------------------------------------------------------------- */}
      <div className={classes.nav}>
        <p className={classes.filterBy}>Filter by</p>
        <button
          className={classes.reset}
          onClick={(e) => handleCheckAllChange(e)}
        >
          Reset Filters
        </button>
      </div>
      {/* number of results container */}
      {/* -------------------------------------------------------------------- */}
      <div className={classes.content}>
        <p>{results.length} results</p>
      </div>
      {/* facets container */}
      {/* -------------------------------------------------------------------- */}
      <div className={classes.footer}>
        <p className={classes.subTitle}>ARTIST</p>
        {/* create all the checkboxes depending on the API data */}
        {/* Artists facet */}
        <Checkbox
          apiLink={Constants.facetsApiLink}
          list={artistsFacet}
          setList={setArtistsFacet}
          selected={selectedArtists}
          setSelected={setSelectedArtists}
          prefix={prefixes[0]}
        />
        <p className={classes.subTitle}>LANGUAGE</p>
        {/* create all the checkboxes depending on the API data */}
        {/* <div className={classes.checkbox}>Hola</div> */}
        {/* Languages facet */}
        <Checkbox
          apiLink={Constants.facetsApiLink}
          list={languagesFacet}
          setList={setLanguagesFacet}
          selected={selectedLanguages}
          setSelected={setSelectedLanguages}
          prefix={prefixes[1]}
        />
        <p className={classes.subTitle}>Genre</p>
        {/* Genre facet */}
        <Checkbox
          apiLink={Constants.facetsApiLink}
          list={genresFacet}
          setList={setGenresFacet}
          selected={selectedGenres}
          setSelected={setSelectedGenres}
          prefix={prefixes[2]}
        />
        {/* Artist popularity slider */}
        <p className={classes.subTitle}>ARTIST POPULARITY</p>
        <div className={classes.slider}>
          <div className={classes.value}>
            {valuesPopularity[0]} - {valuesPopularity[1]}
          </div>
          <small>
            Current Range: {valuesPopularity[1] - valuesPopularity[0]}
          </small>
          <Slider
            className={classes.sliderBar}
            thumbClassName={classes.thumb}
            trackClassName={classes.track}
            onAfterChange={setValuesPopularity}
            value={valuesPopularity}
            min={minPopularity}
            max={maxPopularity}
            renderThumb={(props, state) => (
              <div {...props}>{state.valueNow}</div>
            )}
          />
        </div>
        <p className={classes.subTitle}>NUMBER OF SONGS</p>
        <div className={classes.slider}>
          <div className={classes.value}>
            {/* {valuesSongs[0]} - {valuesSongs[1]} */}
          </div>
          {/* <small>Current Range: {valuesSongs[1] - valuesSongs[0]}</small> */}
          <small>Current Range: {valuesSongs}</small>
          <Slider
            // className={classes.sliderBar}
            // thumbClassName={classes.thumb}
            // trackClassName={classes.track}
            onAfterChange={setValuesSongs}
            value={valuesSongs}
            // min={minSongs}
            min={1}
            max={maxSongs}
            className={classes.sliderBar}
            thumbClassName={classes.thumb}
            trackClassName={classes.track}
            renderThumb={(props, state) => (
              <div {...props}>{state.valueNow}</div>
            )}
          />
        </div>
      </div>
      {/* results container */}
      {/* -------------------------------------------------------------------- */}
      <div className={classes.results}>
        {/* <h1>BUSCADOR MIEO.</h1>
        {selectedArtists.map((a, i) => (
          <div key={i}>{a}</div>
        ))}
        {selectedLanguages.map((a, i) => (
          <div key={i}>{a}</div>
        ))}
        {selectedGenres.map((a, i) => (
          <div key={i}>{a}</div>
        ))} */}
        <SearchResultsList results={currentPosts} />
        <Pagination
          totalPosts={results.length}
          postsPerPage={postsPerPage}
          setCurrentPage={setCurrentPage}
          currentPage={currentPage}
        />
      </div>
    </div>
  );
};

export default Home;
