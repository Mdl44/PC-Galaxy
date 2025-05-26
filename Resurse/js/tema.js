document.addEventListener("DOMContentLoaded", function() {
    const savedTheme = localStorage.getItem("tema");
    
    document.body.classList.remove('default', 'light', 'dark');
    
    if(savedTheme) {
        document.body.classList.add(savedTheme);
    }
    
    const currentThemeOption = document.querySelector(`.theme-option[data-theme="${savedTheme || 'default'}"]`);
    if (currentThemeOption) {
        document.querySelectorAll('.theme-option').forEach(opt => {
            opt.classList.remove('active');
        });
        currentThemeOption.classList.add('active');
    }
});