import Phaser from "phaser";
import Flood from './scenes/Flood';
import { useState} from "react";

let game = null;

function App() {
  const [loaded, setLoaded] = useState(false);

  if (!loaded) {
    setLoaded(true);
    // const config = {
    //   type: Phaser.AUTO,
    //   parent: "game-container",
    //   autoCenter: Phaser.Scale.CENTER_HORIZONTALLY,
    //   autoFocus: true,
    //   fps: {
    //     target: 60,
    //   },
    //   physics: {
    //     default: "arcade",
    //     arcade: {
    //       gravity: { y: 200 },
    //       debug: false,
    //     },
    //   },
    //   backgroundColor: "#282c34",
    //   scale: {
    //     mode: Phaser.Scale.ScaleModes.NONE,
    //   },
    //   scene: [Flood],
    // };
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

  return <> </>;
}

export default App;
