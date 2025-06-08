// Sepet verilerini al ve sayfada göster
document.addEventListener('DOMContentLoaded', () => {
    const cartItemsContainer = document.getElementById('cart-items');
    const totalPriceElement = document.getElementById('total-price');

    // LocalStorage'dan sepet verilerini al
    const cart = JSON.parse(localStorage.getItem('cart')) || [];

    if (cart.length === 0) {
        cartItemsContainer.innerHTML = "<p>Sepetiniz boş.</p>";
    } else {
        let totalPrice = 0;
        cart.forEach(item => {
            // Ürünleri sepete ekle
            const itemElement = document.createElement('div');
            itemElement.classList.add('cart-item');
            itemElement.innerHTML = `
                <p>${item.name} - ${item.price}</p>
            `;
            cartItemsContainer.appendChild(itemElement);

            // Toplam fiyatı hesapla
            const price = parseFloat(item.price.replace('₺', '').trim());
            totalPrice += price;
        });

        // Toplam fiyatı güncelle
        totalPriceElement.textContent = totalPrice.toFixed(2);
    }
});
