

document.querySelectorAll('.menu-button').forEach(button => {
    button.addEventListener('click', () => {
        const submenu = button.nextElementSibling;
        const isActive = button.classList.contains('active');

        // Ferme tous les autres sous-menus
        document.querySelectorAll('.submenu.active').forEach(menu => {
            if (menu !== submenu) {
                menu.classList.remove('active');
                menu.previousElementSibling.classList.remove('active');
            }
        });

        // Toggle le sous-menu actuel
        button.classList.toggle('active');
        if (submenu && submenu.classList.contains('submenu')) {
            submenu.classList.toggle('active');
        }
    });
}); 
