# VitalikPlace: SmartContract de Marketplace de NFTs

## Descripción

VitalikPlace es un contrato inteligente de Marketplace de NFTs descentralizado construido en Ethereum. Permite a los usuarios listar, comprar, deslistar y actualizar los precios de sus NFTs. El contrato proporciona una forma segura y transparente de comerciar tokens ERC721.

### Características Principales:
- Listar NFTs para la venta
- Comprar NFTs listados
- Deslistar NFTs
- Actualizar precios de NFTs listados
- Ver precios de NFTs listados

### Tecnologías utilizadas:
- **Smart Contracts:** Solidity
- **Entorno de Desarrollo:** Foundry
- **Front-end:** React + Wagmi
- **Tests:** Pruebas unitarias con Foundry

## Fundamentos del Diseño y Patrones de Diseño en Solidity

### 1. Reentrancy Guard

Hemos implementado el `ReentrancyGuard` de OpenZeppelin para proteger contra ataques de reentrada. Esto es crucial para funciones que involucran transferencias de Ether o tokens.

```solidity
contract VitalikPlace is ReentrancyGuard {
    // ...
}
```

**Patrón Utilizado**: Reentrancy Guard
**Razón**: Previene que contratos maliciosos vuelvan a entrar en el contrato durante cambios de estado, mejorando la seguridad.

### 2. Patrón Checks-Effects-Interactions

En funciones como `buyNFT`, seguimos el patrón Checks-Effects-Interactions:

1. Comprobar condiciones
2. Actualizar estado
3. Interactuar con contratos externos

```solidity
function buyNFT(address nftAddress, uint256 tokenId) external payable nonReentrant {
    // Comprobaciones
    Listing memory listing = listings[nftAddress][tokenId];
    require(listing.price > 0, "El NFT no está listado para la venta");
    require(msg.value >= listing.price, "Ether insuficiente para cubrir el precio de venta");

    // Efectos
    delete listings[nftAddress][tokenId];

    // Interacciones
    IERC721(nftAddress).safeTransferFrom(address(this), msg.sender, tokenId);
    payable(listing.seller).transfer(listing.price);

    emit NFTSold(nftAddress, tokenId, msg.sender, listing.price);
}
```

**Patrón Utilizado**: Checks-Effects-Interactions
**Razón**: Minimiza el riesgo de ataques de reentrada y asegura un flujo claro y lógico de operaciones.

### 3. Emisión de Eventos

Emitimos eventos para todos los cambios de estado significativos:

```solidity
event NFTListed(address indexed nftAddress, uint256 indexed tokenId, address indexed seller, uint256 price);
event NFTSold(address indexed nftAddress, uint256 indexed tokenId, address indexed buyer, uint256 price);
event NFTUnlisted(address indexed nftAddress, uint256 indexed tokenId, address indexed seller);
event NFTPriceUpdated(address indexed nftAddress, uint256 indexed tokenId, uint256 newPrice);
```

**Patrón Utilizado**: Event Emission
**Razón**: Permite un seguimiento eficiente fuera de la cadena de los cambios de estado del contrato y proporciona una pista de auditoría clara.

### 4. Access Control

Usamos comprobaciones simples de control de acceso para asegurar que solo usuarios autorizados puedan realizar ciertas acciones:

```solidity
require(listing.seller == msg.sender, "Debes ser el vendedor para actualizar el precio");
```

**Patrón Utilizado**: Access Control
**Razón**: Asegura que solo el propietario legítimo de un NFT pueda modificar su listado o precio.


### Integrantes: 
- [Juan Pablo Villaplana](https://github.com/PabloVillaplana)
- [Diana Novoa](https://github.com/nov0ax)
- [Anouk Rímola](https://github.com/AnoukRImola)
