import { Socket, Presence } from "phoenix";

const socket = new Socket("/socket", { params: { token: window.userToken } });
socket.connect();

function renderOnlineUsers(presence) {
  let response = "";

  presence.list((id, { metas: [first] }) => {
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
}

const match = document.location.pathname.match(/\/games\/([0-9a-fA-F\-]{36})$/);

if (match) {
  document.querySelector("#joinButton").addEventListener("click", () => {
    const name = document.querySelector("#nameField").value;
    const joinDiv = document.querySelector(".join");
    joinDiv.style.display = "none";

    const id = match[1];
    const channel = socket.channel(`game:${id}`, { name });
    const presence = new Presence(channel);
    presence.onSync(() => renderOnlineUsers(presence));

    channel
      .join()
      .receive("ok", (resp) => {
        console.log("Joined successfully", resp);
      })
      .receive("error", (resp) => {
        console.log("Unable to join", resp);
      });

    document.querySelector("#voteButton").addEventListener("click", () => {
      const content = document.querySelector("#vote").value;
      channel.push("vote:set", { vote: content });
    });
  });
}

export default socket;
