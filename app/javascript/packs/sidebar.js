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

function setLocalStorageCurrentPath() {
	const cur_path = window.location.pathname;
	if (cur_path.includes('events')) {
		localStorage.setItem('cur_tab', 'events-tab');
	} else if (cur_path.includes('images')) {
		localStorage.setItem('cur_tab', 'gallery-tab');
	} else if (cur_path.includes('profile')) {
		localStorage.setItem('cur_tab', 'profile-tab');
	} else if (cur_path.includes('permission')) {
		localStorage.setItem('cur_tab', 'manage-users-tab');
	} else if (cur_path.includes('help')) {
		localStorage.setItem('cur_tab', 'help-tab');
	} else { // root tab or home tab will show home tab as active
		localStorage.setItem('cur_tab', 'home-tab');
	}
}

function setCurrentTabActive(navLinkColor)
{
	setLocalStorageCurrentPath();

	// load the current active tab (home tab when just logged in)
	if(navLinkColor){
		navLinkColor.forEach(l=> l.classList.remove('active'))
		const cur_tab = document.getElementById(localStorage.getItem('cur_tab'));
		// only add to classList of cur_tab if it exists
		if (cur_tab) {
			cur_tab.classList.add('active');
		}
	}
}

function onReady() {
	const toggle = document.getElementById('header-toggle'),
	nav = document.getElementById('nav-bar'),
	headerpd = document.getElementById('header');

	toggleNavbar(toggle, nav, headerpd);
	
	const navLinkColor = document.querySelectorAll('.tab')
	setCurrentTabActive(navLinkColor);

	/*===== LINK ACTIVE =====*/
	function colorLink() {
		if (navLinkColor) {
			// delete all active tabs
			navLinkColor.forEach(l => l.classList.remove('active'));
			// get the tab that is clicked on and save it localled for reloading
			const cur_tab = (this.id != 'root-tab') ? this.id : 'home-tab'; // root tab is home tab
			localStorage.setItem('cur_tab', cur_tab);

			// add "active" class to tab being clicked on to get active to appear sooner visually though it will load again after
			// redirect
			document.getElementById(cur_tab).classList.add('active');
	
		}
		event.stopPropagation();
	}

	navLinkColor.forEach(l => l.addEventListener('click', colorLink))	
}




