"use strict";

console.log("Sidebar JS file loaded but nothing is done here")

if (document.readyState !== "loading") {
	console.log("Not loading yet");
	onReady();
} else {
	console.log("Loading RN");
	document.addEventListener("DOMContentLoaded", onReady);
}

const showNavbar = (toggleId, navId, bodyId, headerId) =>{
	const toggle = document.getElementById(toggleId),
	nav = document.getElementById(navId),
	bodypd = document.getElementById(bodyId),
	headerpd = document.getElementById(headerId);
	console.log(toggle);
	console.log(nav);
	console.log(bodypd);
	console.log(headerpd);
	
	// Validate that all variables exist
	if(toggle && nav && bodypd && headerpd){
		toggle.addEventListener('click', ()=>{
		// show navbar
		nav.classList.toggle('show')
		// change icon
		toggle.classList.toggle('bx-x')
		// add padding to body
		// bodypd.classList.toggle('body-pd')
		// add padding to header
		headerpd.classList.toggle('body-pd')

		console.log("Added Toggle Function");
		})
	}
	console.log("Show Nav Bar Ran");
}




function onReady() {
	
	console.log("Getting ready");
	showNavbar('header-toggle','nav-bar','body-pd','header')
	
	/*===== LINK ACTIVE =====*/
	const linkColor = document.querySelectorAll('.nav_link')
	
	function colorLink(){
		if(linkColor){
			linkColor.forEach(l=> l.classList.remove('active'))
			this.classList.add('active')
		}
		console.log("Color Link ran");
	}
	
	linkColor.forEach(l=> l.addEventListener('click', colorLink))
}