import { Socket, Presence } from "phoenix";

const socket = new Socket("/socket", { params: { token: window.userToken } });
socket.connect();

function Channel(gameId, name) {
  this.channel = socket.channel(`game:${gameId}`, { name });
  this.presence = new Presence(this.channel);
  this.presence.onSync(() => this.renderPlayers());

  this.join = function () {
    this.channel
      .join()
      .receive("error", (err) => console.log("Failed to join: ", err));
  };

  this.vote = function (input) {
    this.channel.push("vote:set", { vote: input });
  };

  this.renderPlayers = function () {
    let response = "";

    this.presence.list((id, { metas: [first] }) => {
      response += `
      <div class="player">
        <div class="card">
          ${first.vote === -1 ? "" : first.vote}
        </div>
        <div class="name">
          ${id}
        </div>
      </div>
    `;
    });

    document.querySelector(".players").innerHTML = response;
  };
}

window.Channel = Channel;
