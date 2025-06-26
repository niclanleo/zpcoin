// SPDX-License-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts for Cairo 2.0.0

#[starknet::contract]
mod zpc {
    use openzeppelin::token::erc20::{ERC20Component, ERC20HooksEmptyImpl};
    use openzeppelin::access::ownable::OwnableComponent;
    use openzeppelin::token::erc20::interface::{IERC20, IERC20Metadata};
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use core::integer::u256;

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

    #[abi(embed_v0)]
    impl ERC20Impl = ERC20Component::ERC20Impl<ContractState>;
    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableMixinImpl<ContractState>;

    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

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

    #[constructor]
    fn constructor(ref self: ContractState) {
        let owner = get_caller_address();
        self.name.write("ZPC");
        self.symbol.write("ZPC");
        self.decimals.write(18);
        self.erc20.initializer("", "");
        self.ownable.initializer(owner);
        // 總供應量：88_888_888 * 10^18
        let total_supply: u256 = 88888888_000000000000000000_u256;
        self.erc20.mint(owner, total_supply);
    }
}