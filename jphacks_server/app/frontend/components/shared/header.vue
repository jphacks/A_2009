<template lang="pug">
b-navbar(toggleable="lg" type="dark" variant="dark")
  b-navbar-brand(href="/")
    img(
      src="../assets/logo.png"
      alt="VeleLogo"
      class="navbar__logo"
    )
  b-navbar-toggle(target="nav-collapse")
  b-collapse(id="nav-collapse" is-nav)
  b-navbar-nav
    b-nav-item(href="/materials/new")
      | 資料共有
</template>

<script>
export default {
  name: 'Header'
}
</script>

<style scoped>
.navbar__logo {
  height: 45px;
  margin-left: 10px;
}
</style>