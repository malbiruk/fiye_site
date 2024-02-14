document.addEventListener('DOMContentLoaded', function () {
  const front = document.querySelector('.wrapper');

  front.addEventListener('click', function () {
    // Get all the elements you wanna animate
    const env = document.querySelector('.env');
    const img = document.querySelector('img');
    const lettre = document.querySelector('.lettre');

    // Add the animation class to kick things off
    env.classList.add('animateEnv');
    img.classList.add('animateHeart');
    lettre.classList.add('animateLettre');
  });
});
