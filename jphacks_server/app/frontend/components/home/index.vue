<template lang="pug">
b-container(class="bv-example-row")
  b-row(class="text-center")
    b-col(col lg="2")
    b-col(col lg="8")
      img(
        src="../assets/logo.png"
        alt="VeleLogo"
        class="homeLogo"
      )
      h2 ようこそ
      b-button(
        variant="outline-primary"
        href="/materials/new"
        class="button"
      )
        | さっそく使ってみる
    b-col(col lg="2")
</template>

<style scoped>
.homeLogo {
  text-align: center;
  height: 150px;
  margin: 20px;
}
.button {
  margin: 10px;
}
</style>