"use strict";

var connection = new signalR.HubConnectionBuilder().withUrl("/presentationHub").build();

document.getElementById("next").disabled = true;
document.getElementById("prev").disabled = true;

var hidden = [];
var currentIndex = 0;
var total = 0;

const showSlide = () => {
    if (currentIndex <= 0) return;
    if (currentIndex > total) return;
    if (hidden.indexOf(currentIndex) >= 0) return;
    Array.from(document.querySelectorAll('.visible')).forEach(function (el) {
        el.classList.remove('visible');
    });

    document.getElementById('slide-' + currentIndex).classList.add('visible');
}

connection.on("LoadSlides", function (data) {
    hidden = data.hidden;
    currentIndex = data.current;
    total = data.count;
    for (let i = 1; i <= total; i++) {
        var img = document.createElement("img");
        img.id = 'slide-' + i;
        img.src = `/slides/slide${i}.png`;

        document.getElementById("presentation").appendChild(img);
    };
    setTimeout(() => showSlide(), 1000);
});

connection.on("RefreshSlide", function (data) {
    if (data <= 0 || data > total) return;

    currentIndex = data;
    showSlide();
});

connection.start().then(function () {
    document.getElementById("next").disabled = false;
    document.getElementById("prev").disabled = false;
}).catch(function (err) {
    return console.error(err.toString());
});

document.getElementById("next").addEventListener("click", function (event) {
    connection.invoke("SetSlide", currentIndex + 1).catch(function (err) {
        return console.error(err.toString());
    });
    event.preventDefault();
});

document.getElementById("prev").addEventListener("click", function (event) {
    connection.invoke("SetSlide", currentIndex - 1).catch(function (err) {
        return console.error(err.toString());
    });
    event.preventDefault();
});