// Sepete ekleme fonksiyonu
function addToCart(product) {
    // Sepet verisini al (ya da boş bir dizi oluştur)
    let cart = JSON.parse(localStorage.getItem('cart')) || [];

    // Ürünü sepete ekle
    cart.push(product);

    // Sepeti tekrar localStorage'a kaydet
    localStorage.setItem('cart', JSON.stringify(cart));
}

// Sepete Ekle butonlarına tıklama olayını dinle
document.addEventListener('DOMContentLoaded', () => {
    const buttons = document.querySelectorAll('.add-to-cart-btn');

    buttons.forEach(button => {
        button.addEventListener('click', (event) => {
            const productCard = event.target.closest('.product-card');
            const productId = productCard.getAttribute('data-product-id');
            const productName = productCard.querySelector('h2').innerText;
            const productPrice = productCard.querySelector('p').innerText;

            // Ürün bilgilerini al
            const product = {
                id: productId,
                name: productName,
                price: productPrice
            };

            // Sepete ekle
            addToCart(product);
        });
    });
});

function toggleDropdown() {
    var dropdownContent = document.getElementById("dropdownContent");
    dropdownContent.classList.toggle("show");

    // Kullanıcı giriş yapmışsa menü içeriğini değiştir
    if (typeof kullaniciGirisYapmis !== 'undefined' && kullaniciGirisYapmis) {
        dropdownContent.innerHTML = `
            <a href="#">Hesap Bilgilerim</a>
            <a href="#">Tüm Siparişlerim</a>
            <a href="#">Çıkış</a>
        `;
    } else {
        // Kullanıcı giriş yapmamışsa varsayılan menü içeriğini göster
        dropdownContent.innerHTML = `
            <a href="login.aspx">Üye Giriş</a>
            <a href="signin.aspx">Üye Ol</a>
        `;
    }
}

// Sayfa yüklendiğinde dropdown'ı kapat (varsayılan davranış)
window.onclick = function (event) {
    if (!event.target.matches('.dropbtn')) {
        var dropdowns = document.getElementsByClassName("dropdown-content");
        for (var i = 0; i < dropdowns.length; i++) {
            var openDropdown = dropdowns[i];
            if (openDropdown.classList.contains('show')) {
                openDropdown.classList.remove('show');
            }
        }
    }
};