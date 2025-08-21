ListPropertyAssignBehavior: pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris


Singleton {
  id: manager

  property bool canControl: currentPlayer ? currentPlayer.canControl : false
  property bool canGoNext: currentPlayer ? currentPlayer.canGoNext : false
  property bool canGoPrevious: currentPlayer ? currentPlayer.canGoPrevious : false
  property bool canPause: currentPlayer ? currentPlayer.canPause : false
  property bool canPlay: currentPlayer ? currentPlayer.canPlay : false
  property bool canSeek: currentPlayer ? currentPlayer.canSeek : false

  // Expose cava values
  property alias cavaValues: cava.values
  property var currentPlayer: null
  property real currentPosition: 0
  property bool hasPlayer: getAvailablePlayers().length > 0
  property bool isPlaying: currentPlayer ? currentPlayer.isPlaying : false
  property int selectedPlayerIndex: 0
  property bool shuffle: currentPlayer.shuffle
  readonly property bool shuffleSupported: currentPlayer ? currentPlayer.shuffleSupported : false
  property string trackAlbum: currentPlayer ? (currentPlayer.trackAlbum || "Unknown Album") : ""
  property string trackArtUrl: currentPlayer ? (currentPlayer.trackArtUrl || "") : ""
  property string trackArtist: currentPlayer ? (currentPlayer.trackArtist || "Unknown Artist") : ""
  property real trackLength: currentPlayer ? currentPlayer.length : 0
  property string trackTitle: currentPlayer ? (currentPlayer.trackTitle || "Unknown Track") : ""

  function findActivePlayer() {
    let availablePlayers = getAvailablePlayers();
    if (availablePlayers.length === 0) {
      return null;
    }

    if (selectedPlayerIndex < availablePlayers.length) {
      return availablePlayers[selectedPlayerIndex];
    } else {
      selectedPlayerIndex = 0;
      return availablePlayers[0];
    }
  }

  function getAvailablePlayers() {
    if (!Mpris.players || !Mpris.players.values) {
      return [];
    }

    let allPlayers = Mpris.players.values;
    let controllablePlayers = [];

    for (let i = 0; i < allPlayers.length; i++) {
      let player = allPlayers[i];
      if (player && player.canControl) {
        controllablePlayers.push(player);
      }
    }

    return controllablePlayers;
  }

  function next() {
    if (currentPlayer && currentPlayer.canGoNext) {
      currentPlayer.next();
    }
  }

  function pause() {
    if (currentPlayer && currentPlayer.canPause) {
      currentPlayer.pause();
    }
  }

  function play() {
    if (currentPlayer && currentPlayer.canPlay) {
      currentPlayer.play();
    }
  }

  function playPause() {
    if (currentPlayer) {
      if (currentPlayer.isPlaying) {
        currentPlayer.pause();
      } else {
        currentPlayer.play();
      }
    }
  }

  function previous() {
    if (currentPlayer && currentPlayer.canGoPrevious) {
      currentPlayer.previous();
    }
  }

  function seek(position) {
    if (currentPlayer && currentPlayer.canSeek) {
      currentPlayer.position = position;
      currentPosition = position;
    }
  }

  // Seek to position based on ratio (0.0 to 1.0)
  function seekByRatio(ratio) {
    if (currentPlayer && currentPlayer.canSeek && currentPlayer.length > 0) {
      let seekPosition = ratio * currentPlayer.length;
      currentPlayer.position = seekPosition;
      currentPosition = seekPosition;
    }
  }

  function shuffle() {
    if (currentPlayer && currentPlayer.shuffleSupported && currentPlayer.canControl) {
      manager.shuffle = !manager.shuffle;
    }
  }

  // Switch to the most recently active player
  function updateCurrentPlayer() {
    let newPlayer = findActivePlayer();
    if (newPlayer !== currentPlayer) {
      currentPlayer = newPlayer;
      currentPosition = currentPlayer ? currentPlayer.position : 0;
    }
  }

  // Reset position when switching to inactive player
  onCurrentPlayerChanged: {
    if (!currentPlayer || !currentPlayer.isPlaying || currentPlayer.playbackState !== MprisPlaybackState.Playing) {
      currentPosition = 0;
    }
  }

  Item {
    Component.onCompleted: {
      updateCurrentPlayer();
    }
  }

  // Update progress bar every second while playing
  Timer {
    id: positionTimer

    interval: 1000
    repeat: true
    running: currentPlayer && currentPlayer.isPlaying && currentPlayer.length > 0 && currentPlayer.playbackState === MprisPlaybackState.Playing

    onTriggered: {
      if (currentPlayer && currentPlayer.isPlaying && currentPlayer.playbackState === MprisPlaybackState.Playing) {
        currentPosition = currentPlayer.position;
      } else {
        running = false;
      }
    }
  }

  // Update current player when available players change
  Connections {
    function onValuesChanged() {
      updateCurrentPlayer();
    }

    target: Mpris.players
  }

  Cava {
    id: cava

    count: 86
  }
}
