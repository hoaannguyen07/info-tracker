"use strict";

if (document.readyState !== "loading") {
	onReady();
} else {
	document.addEventListener("DOMContentLoaded", onReady);
}

const toggleNavbar = (toggle, nav, headerpd) =>{
	console.log(toggle);
	console.log(nav);
	console.log(headerpd);
	// Validate that all variables exist
	if(toggle && nav && headerpd){
		toggle.addEventListener('click', ()=>{
			// show navbar
			nav.classList.toggle('show')
			// change icon
			toggle.classList.toggle('bx-x')
			// add padding to header
			headerpd.classList.toggle('body-pd')

			console.log(toggle);
			console.log(nav);
			console.log(headerpd);
		})
	}
}

function setCurrentTab(navLinkColor)
{
	// set cur_tab if there are no save cur_tab or if cur_tab is empty/undefined
	if (localStorage.length == 0 || !localStorage.getItem('cur_tab'))
	{
		localStorage.setItem('cur_tab', 'home-tab');
	}

	// load the current active tab (home tab when just logged in)
	if(navLinkColor){
		navLinkColor.forEach(l=> l.classList.remove('active'))
		const cur_tab = document.getElementById(localStorage.getItem('cur_tab'));
		cur_tab.classList.add('active');
	}
}

function onReady() {
	const toggle = document.getElementById('header-toggle'),
	nav = document.getElementById('nav-bar'),
	headerpd = document.getElementById('header');

	toggleNavbar(toggle, nav, headerpd);
	
	const navLinkColor = document.querySelectorAll('.tab')
	setCurrentTab(navLinkColor);

	/*===== LINK ACTIVE =====*/
	function colorLink() {
		if (navLinkColor) {
			// delete all active tabs
			navLinkColor.forEach(l => l.classList.remove('active'));
			// get the tab that is clicked on and save it localled for reloading
			const cur_tab = (this.id != 'root-tab') ? this.id : 'home-tab';
			localStorage.setItem('cur_tab', cur_tab);

			// add "active" class to tab being clicked on to get active to appear sooner visually though it will load again after
			// redirect
			document.getElementById(cur_tab).classList.add('active');
	
		}
		event.stopPropagation();
	}

	navLinkColor.forEach(l => l.addEventListener('click', colorLink))	
}




