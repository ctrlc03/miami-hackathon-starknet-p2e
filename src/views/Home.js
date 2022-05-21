import React, { useState } from 'react';
import Hero from '../components/sections/Hero';
import Phaser from "phaser";
import Flood from '../scenes/Flood';

let game = null;

const Home = () => {
  const [loaded, setLoaded] = useState(false);


  if (!loaded) {
    setLoaded(true);

    var config = {
      type: Phaser.AUTO,
      autoCenter: Phaser.Scale.CENTER_HORIZONTALLY,
      width: 800,
      height: 600,
      pixelArt: true,
      parent: "game-container",
      scene: [ Flood ]
  };
  
    if (game === null) {
      game = new Phaser.Game(config);
      }
  }

  return (
    <>
      <Hero className="illustration-section-01" />
    </>
  );
}

export default Home;