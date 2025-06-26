// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts for Cairo 2.0.0

#[starknet::contract]
mod zpc {
    use openzeppelin::token::erc20::{ERC20Component, ERC20HooksEmptyImpl};
    use openzeppelin::access::ownable::OwnableComponent;
    use openzeppelin::token::erc20::interface::{IERC20, IERC20Metadata};
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use core::integer::u256;

    // 宣告 ERC20 與 Ownable component
    component!(path: ERC20Component, storage: erc20, event: ERC20Event);
    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc20: ERC20Component::Storage,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        name: ByteArray,
        symbol: ByteArray,
        decimals: u8,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC20Event: ERC20Component::Event,
        #[flat]
        OwnableEvent: OwnableComponent::Event,
    }

    // 將 ERC20 與 Ownable 的標準 external 接口導出為合約 ABI
    #[abi(embed_v0)]
    impl ERC20Impl = ERC20Component::ERC20Impl<ContractState>;
    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableMixinImpl<ContractState>;

    // 匯入內部實作以供合約內部調用
    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    // 額外補上 ERC20Metadata 的 ABI 實作
    #[abi(embed_v0)]
    impl ERC20Metadata of IERC20Metadata<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            self.name.read()
        }
        fn symbol(self: @ContractState) -> ByteArray {
            self.symbol.read()
        }
        fn decimals(self: @ContractState) -> u8 {
            self.decimals.read()
        }
    }

    // 建構函式：初始化 owner 與 mint 初始總供應量
    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        self.ownable.initializer(owner);
        self.erc20.initializer("ZPC", "ZPC");
        self.name.write("ZPC");
        self.symbol.write("ZPC");
        self.decimals.write(18); // 設置為 18 或其他適當值
        let total_supply: u256 = 88888888_000000000000000000_u256;
        self.erc20.mint(owner, total_supply);
    }
}