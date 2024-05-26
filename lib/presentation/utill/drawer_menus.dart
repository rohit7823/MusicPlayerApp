import 'package:flutter/material.dart';

enum DrawerMenus {
  home(Icons.home, "Home"),
  songs(Icons.music_note, "Songs"),
  wrapInMusic(Icons.queue_music_rounded, "Wrap In Music"),
  services(Icons.people, "Services"),
  contactUs(Icons.phone, "Contact us"),
  login(Icons.person_outline_outlined, "Login"),
  cart(Icons.shopping_cart_outlined, "Cart");

  final IconData icon;
  final String menu;

  const DrawerMenus(this.icon, this.menu);
}
