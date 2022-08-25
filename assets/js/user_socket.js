import { Socket, Presence } from "phoenix";
import Alpine from "alpinejs";

const socket = new Socket("/socket", { params: { token: window.userToken } });
socket.connect();

window.Alpine = Alpine;

Alpine.store("game", {
  players: [],
  isRevealed: false,
  setPlayers(players) {
    this.players = players;
  },
  setIsRevealed(newIsRevealed) {
    this.isRevealed = newIsRevealed;
  },
});

Alpine.start();

function Channel(gameId, name) {
  this.channel = socket.channel(`game:${gameId}`, { name });
  this.presence = new Presence(this.channel);
  this.presence.onSync(() => this.onSync());

  this.join = function () {
    this.channel
      .join()
      .receive("error", (err) => console.log("Failed to join: ", err));
  };

  this.push = function (topic, data) {
    this.channel.push(topic, data);
  };

  this.onSync = function () {
    this.presence.list((id, { metas }) => {
      if (id === "users") {
        Alpine.store("game").setPlayers(metas);
      }
      if (id === "isRevealed") {
        Alpine.store("game").setIsRevealed(metas[0].value);
      }
    });
  };
}

window.Channel = Channel;
