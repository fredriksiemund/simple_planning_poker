import { Socket, Presence } from "phoenix";
import Alpine from "alpinejs";

const socket = new Socket("/socket", { params: { token: window.userToken } });
socket.connect();

window.Alpine = Alpine;

Alpine.store("players", {
  data: [],
  setPlayers(data) {
    this.data = data;
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

  this.vote = function (input) {
    this.channel.push("vote:set", { vote: parseInt(input) });
  };

  this.onSync = function () {
    this.presence.list((id, { metas }) => {
      if (id === "users") {
        Alpine.store("players").setPlayers(metas);
      }
    });
  };
}

window.Channel = Channel;
