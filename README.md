Used to compress tables sent over the [net-messaging system](http://wiki.garrysmod.com/page/Category:net) to lessen the strain on servers and clients sending large amounts of data.

This is done by overwriting [net.WriteTable](http://wiki.garrysmod.com/page/net/WriteTable) & [net.ReadTable](http://wiki.garrysmod.com/page/net/ReadTable) to compress or decompress the table.

See the **Accessible functions** section below to use either the vanilla or compressing versions explicitly.

Requirements
============

https://github.com/vercas/vON

**OR**

https://github.com/yupi2/vON

Accessible functions
====================

- net.OrigWriteTable       - The original net.WriteTable function
- net.OrigReadTable        - The original net.ReadTable function
- net.WriteCompressedTable - The net.WriteTable version that compresses
- net.ReadCompressedTable  - The net.ReadTable version that decompresses
