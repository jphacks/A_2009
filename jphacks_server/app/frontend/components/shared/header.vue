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
  b-navbar-nav(class="ml-auto")
    b-nav-form
      b-form-input(size="sm" class="mr-sm-2" placeholder="Search")
      b-button(size="sm" class="my-2 my-sm-0" type="submit") Search
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