<nav>
	<div class="theme-switch-wrapper d-flex align-self-center">
		<label class="theme-switch position-relative d-inline-block" for="checkbox" style="width: 55px; height: 26px;">
			<input type="checkbox" id="checkbox" class="d-none" />
			<div class="slider pointer position-absolute rounded-pill top-0 bottom-0 start-0 end-0" style="outline: 1px solid var(--bs-border-color);">
				<div class="h-100 moon-sun p-1 d-flex align-items-center justify-content-between">
					<i class="fa-solid fa-moon text-white"></i>
					<i class="fa-solid fa-sun text-warning"></i>
				</div>
			</div>
		</label>
	</div>
<style>
.theme-switch .slider { background-color: var(--bs-body-bg); transition: .4s; }
.theme-switch .moon-sun i {  transition: opacity .15s ease; }
.theme-switch .slider.hide-moon .fa-moon, .theme-switch .slider.hide-sun .fa-sun { opacity: 0; }
.theme-switch .slider:before {
  background-color: #1b73f9;
  bottom: 3px;
  content: "";
  height: 20px;
  width: 20px;
  left: 4px;
  position: absolute;
  transition: .4s;
  border-radius: 50px;
  z-index: 1;
}
.theme-switch input:checked + .slider { background-color: var(--bs-body-bg); }
.theme-switch input:checked + .slider:before { transform: translateX(28px); }
</style>
<script>
const toggleSwitch = document.querySelector('.theme-switch input[type="checkbox"]');
const slider = document.querySelector('.theme-switch .slider');
const currentTheme = localStorage.getItem('theme');

function syncThemeIcons(theme) {
  slider.classList.toggle('hide-moon', theme === 'light');
  slider.classList.toggle('hide-sun', theme === 'dark');
}

if (currentTheme) {
	document.documentElement.setAttribute('data-bs-theme', currentTheme);
	if (currentTheme === 'dark') {
		toggleSwitch.checked = true;
	}
}

syncThemeIcons(toggleSwitch.checked ? 'dark' : 'light');

slider.addEventListener('transitionend', function (e) {
	if (e.propertyName === 'background-color') {
		syncThemeIcons(toggleSwitch.checked ? 'dark' : 'light');
	}
});

toggleSwitch.addEventListener('change', (e) => {
	const theme = e.target.checked ? 'dark' : 'light';
	document.documentElement.setAttribute('data-bs-theme', theme);
	localStorage.setItem('theme', theme);
	slider.classList.remove('hide-moon', 'hide-sun');
}, false);
</script>
</nav>
