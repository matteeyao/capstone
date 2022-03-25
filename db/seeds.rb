# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Transaction.create!(
    [
        {
            txn_hash: '0x0c3a287ce8b9617dbb2b5b7299076dde7a43edde6f19709c0becd046856076e5',
            summary: 'Specify goods/services transacted for here',
            from: 'John Doe',
            to: 'Jane Doe',
            location: '100 W. Lake St. Addison IL 60101 630-628-0358',
            address: '0x8c469877b27932abdd2313c4b6bf7cff5667fdb9'
        },
        {
            txn_hash: '0x567be1fac6fa34aa0cb273fc2afb6e584bb75b0444784629f252c45ee164f421',
            summary: 'Specify goods/services transacted for here',
            from: 'John Adams',
            to: 'George Washington',
            location: '1600 Pennsylvania Avenue NW Washington, D.C. 20502',
            address: '0x8c469877b27932abdd2313c4b6bf7cff5667fdb9'
        },
        {
            txn_hash: '0xb779cc105c9227a0d04a55a414f2eb21ff81030ae9d7daae7153bf46b425a836',
            summary: 'Bored Ape NFT No. 117',
            from: 'Justin Bieber',
            to: 'Taylor Swift',
            location: '4959 N O\'Connor Rd, Irving, TX 75038',
            address: '0x8c469877b27932abdd2313c4b6bf7cff5667fdb9'
        },
        {
            txn_hash: '0x696a5ebfa085273e574c587554e0806e6c731e7fe63fd4bba05dd6e6404aebe5',
            summary: 'Support for Ukraine',
            from: 'Elon Musk',
            to: 'Volodymyr Zelenskyy',
            location: 'M. Hrushevskoho str., 12/2 Kyiv, Ukraine, 01008',
            address: '0x43085ac677366bd8c114df35a41bf8266aa2142a'
        }
  ]
)
