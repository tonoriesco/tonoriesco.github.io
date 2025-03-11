---
title: De WordPress a Hugo
date: 2020-11-19
featured_image: "/images/posts/wordpress-to-hugo.png"
author: Tono Riesco
omit_header_text: true
toc: true
draft: false
---

# Introducción

Llevo muchos años usando WordPress en mis proyectos de páginas web y blog personal. Lo he recomendado siempre especialmente con clientes que no tienen mucha idea de webs, programación, css, etc. O simplemente que quieren un sitio donde puedan actualizar sus artículos, sitio web, etc. Sin necesidad de programar nada.

Si el sitio tiene que ser para una tienda on-line o una empresa con muchos formularios de contacto, entradas, etc. WordPress es imbatible.

WordPress es un CMS fantástico que impulsa una gran cantidad de sitios web, que tienen características diferentes. Como resultado, tiene una arquitectura bastante robusta que puede parecer demasiado compleja para hace un blog simple. Es por eso que he decidido cambiar a [Hugo](https://gohugo.io) para crear mi blog y que sea simple y rápido, mucho más rápido que WordPress.

Cuando se lanzó WordPress 5, estaba contento con todas las mejoras. Definitivamente fue algo genial de ver lo que había mejorado, pero seguía siendo un sistema muy pesado. Por ejemplo, por cada foto que subo se hacen 6 o 7 copias con todas las resoluciones! Si, si... ya se... es mejor para poner una imagen pequeña o grande dependiendo del cliente, browser, etc.. Pero... 6 ??? No way.

Últimamente, he leído más y más sobre generadores de sitios estáticos y [Static Site Generators](https://learn.cloudcannon.com/jekyll/why-use-a-static-site-generator/) y muchos artículos sobre el tema me convencieron. Con proyectos secundarios personales, se puede "jugar" con muchas cosas, pero como profesional, se debe asegurar la mejor calidad posible.

El rendimiento, la seguridad y la accesibilidad se convierten en las primeras cosas en las que pensar. Definitivamente se puede optimizar WordPress para que sea bastante rápido, pero más rápido que un sitio estático en un CDN que no necesita consultar la base de datos ni generar su página cada vez ???. No tan fácil.

Pensé que podría poner esto en práctica con un proyecto personal mío para aprender y luego poder usarlo para proyectos profesionales, y tal vez a algunos de vosotros también os gustaría saber cómo lo he hecho. En este artículo, repasaré cómo he hecho la transición de WordPress a un generador de sitios estáticos específico llamado Hugo.

Al final he conseguido pasar de:

![riesco-before](/images/posts/riesco-before.jpg)

a:

![riesco-before](/images/posts/riesco-after.jpg)

y después de reducir algunas imágenes acabar con una página Google Pages:

![google-page](/images/posts/google-page.jpg)

# Hugo

Hugo está programado en [Go](https://golang.org) que es un lenguaje bastante rápido y fácil de usar una vez que te acostumbras a la sintaxis, hablaré más tarde de ésto.
Todo se compila localmente y se puede obtener una vista previa de su sitio directamente en el ordenador. Luego, el proyecto se guarda en un repositorio privado de Github si se quiere.

Se puede alojar en cualquier servidor. [Netlify](https://www.netlify.com) es una opción magnífica si no se tiene un servidor o un servicio de web pero eso lo dejaré para otro artículo. Las imágenes se pueden gestionar en un Git LFS (Almacenamiento de archivos grandes). También se puede configurar un sistema de administración de contenido para agregar publicaciones e imágenes (similar al backend de WordPress) con Netlify CMS directamente pero eso también lo dejaré para otro articulo.

Todo ésto es absolutamente gratis, lo cual es bastante sorprendente! Yo trabajo con Mac así que muchas cosas están orientadas a este sistema operativo. Algunos pasos pueden ser ligeramente diferentes, pero se debería poder seguirlos, independientemente de la configuración que utilice.

Hay que sentirse algo cómodo con HTML, CSS, JS, Git y el terminal. Tener algunas nociones con lenguajes de plantillas también podría ser útil, pero revisaremos las plantillas de Hugo para comenzar. No obstante, proporcionaré tantos detalles como sea posible.

Sé que parece mucho, y antes de empezar a investigar esto, también lo era para mí. Trataré de explicar como hacer que esta transición sea lo más sencilla posible desglosando los pasos. No es muy difícil encontrar todos los recursos, pero tuve que hacer muchísimas pruebas al pasar de una documentación a otra.

**Nota**:

Yo me he enfocado a un blog simple y estático que no tiene una docena de widgets o comentarios (puede configurarlos más tarde), y no un sitio de la empresa o una cartera personal. Todo se puede hacer, pero en aras de la simplicidad, me limito a un blog simple y estático.

## Requisitos previos

Antes de hacer nada, hay que crear una carpeta de proyecto donde residirá todo, desde nuestras herramientas hasta nuestro repositorio local. Lo llamaré "dev" (no dudes en llamarlo como quieras).

Este tutorial utilizará algunas herramientas de línea de comandos como npm y Git. Si aún no los tiene, instálelos en su máquina:

* [Instalar Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [Instalar Node.js y npm](https://nodejs.org/en/) (Node.js incluye npm)
* [Instalar Homebrew](https://brew.sh/) (recomendado para usuarios de macOS / Linux)

Para instalar todos los programas desde un Mac lo más sencillo es utilizar Homebrew. Desde el terminal se debe ejecutar:

```bash
brew install git node npm
```

¡Con estos programas instalados, comencemos!

En primer lugar, necesitaremos exportar su contenido de WordPress: publicaciones, páginas y archivos. Hay algunas [herramientas disponibles que menciona Hugo](https://gohugo.io/tools/migrations/#wordpress) pero personalmente, solo una de ellas funcionó: [blog2md](https://github.com/palaniraja/blog2md). Este funciona ejecutando un archivo JavaScript con Node.js en su terminal de comandos. Toma los archivos XML exportados por WordPress y genera archivos Markdown con la estructura correcta, convirtiendo el HTML a Markdown y agregando lo que se llama [Front Matter](https://gohugo.io/content-management/front-matter/), que es una forma de formatear los metadatos al comienzo de cada archivo.

En el administrador de WordPress, en el menú Herramientas, submenú Exportar. Puedes exportar lo que quieras desde allí. Me referiré al archivo exportado como _YOUR-WP-EXPORT.xml_.

![Exportación de WordPress.](/images/posts/wordpress-export.png)

Puede seleccionar exactamente qué datos desea exportar desde su blog de WordPress pero lo mejor en nuestro caso es exportar todo.

Dentro de nuestra carpeta `dev`, recomiendo crear una nueva carpeta llamada `blog2md` en la que colocará los archivos de la herramienta blog2md, así como su exportación XML desde WordPress (_YOUR-WP-EXPORT.xml_). Además, hay que crear una nueva carpeta allí llamada "out" donde irán sus publicaciones de Markdown.

Luego, abre tu terminal de comandos y navega con el [comando `cd`](https://en.wikipedia.org/wiki/Cd_(comando)) hasta tu carpeta" blog2md "recién creada (o escribe`cd` con un espacio y arrastre la carpeta a la terminal).

Ahora puede ejecutar los siguientes comandos para obtener sus publicaciones:

```bash
npm install
nodo index.js w YOUR-WP-EXPORT.xml out
```

Buscar en el directorio `/dev/blog2md/out` para comprobar si todas sus publicaciones (y páginas potenciales) están allí. Si es así, ya te darás cuenta de que faltan los comentarios que habían en WordPress pero Hugo ofrece [varias opciones para comentarios](https://gohugo.io/content-management/comments/). Si tienes algún comentario sobre WordPress, puedes exportarlo para su posterior implementación con un servicio especializado como Disqus.

Yo he pasado muchos días buscando soluciones para los comentarios. Tenía claro que no quería pasar por un servicio como Disqus que además de ser unos spammers tienen muy mala reputación con la protección de datos de los clientes.

Al final, he contado todos los comentarios que he tenido en casi 15 años que tiene este blog y me salen unos 5 o 6 por año!!! No merece la pena pasar un minuto más en programación y soluciones complejas. Al final de cada post, un link con mi email y telegram para que si alguien quiere comentar algo, que lo haga. Luego lo incluiré yo manualmente.

Con esta solución también evito el famoso spam en los comentarios! Perfecto!!

Sigamos!!

Si estás lo suficientemente familiarizado con JS, puedes modificar el archivo _index.js_ para cambiar el resultado de tus archivos de publicación editando la función `wordpressImport`. Es posible que quieras capturar la imagen destacada, eliminar el enlace permanente, cambiar el formato de fecha o establecer el tipo (si tienes publicaciones y páginas). Tendrás que adaptarlo a sus necesidades, pero el bucle (`posts.forEach (function (post) {...})`) recorre todas las publicaciones de la exportación, por lo que puede verificar el XML contenido de cada publicación en ese bucle y personalice tu FrontMatter.

Además, si necesitas actualizar las URL contenidas en sus publicaciones (en mi caso, quería hacer que los enlaces de imágenes fueran relativos en lugar de absolutos) o el formato de la fecha, este es un buen momento para hacerlo, pero no pierdas el sueño. . Muchos editores de texto ofrecen edición masiva para que pueda insertar una expresión regular y realizar los cambios que desees en sus archivos. Además, puede ejecutar el script `blog2md` tantas veces como sea necesario, ya que sobrescribirá cualquier archivo existente previamente en la carpeta de salida.

Yo utilizo Visual Code y tiene muchas herramientas para la edición masiva. Lo recomiendo.

Una vez que tengas sus archivos Markdown exportados, tu contenido estará listo. El siguiente paso es preparar el tema de WordPress para que funcione en Hugo.

## Preparando el diseño del blog

Mi blog tenía un diseño típico con un encabezado, una barra de navegación, contenido y barra lateral, y un pie de página, bastante simple de configurar. En lugar de copiar partes de mi tema de WordPress, lo reconstruí todo desde cero para asegurarme de que no hubiera estilos superfluos o marcas inútiles.

Este es un buen momento para implementar nuevas técnicas CSS (_pssst ... Grid es bastante impresionante!_) Y configurar una estrategia de nomenclatura más consistente (algo así como [las pautas de CSS Wizardry](https://cssguidelin.es/)). Puede hacer lo que quiera, pero recuerda que estamos tratando de optimizar nuestro blog, por lo que es bueno revisar lo que tenía y decidir si aún vale la pena conservarlo.

Después de muchas pruebas, decidí coger un tema ya hecho: [Ananke](https://themes.gohugo.io/gohugo-theme-ananke/) pero podéis coger cualquiera de los [templates que tiene Hugo](https://themes.gohugo.io/)

La mejor solución es coger un tema que nos guste, copiar el directorio que viene casi siempre por defecto en el tema: `exampleSite` y a partir de ahí re-construir el blog.

## Configurando Hugo en el Mac

Primero hay que [instalar Hugo localmente](<https://gohugo.io/getting-started/installing/>) con cualquiera de las opciones proporcionadas. Usaré Homebrew, pero los usuarios de Windows pueden usar Scoop o Chocolatey, o descargar un paquete directamente.

```bash
brew instalar hugo
```

Luego, hay que crear un nuevo sitio de Hugo, hay que elegir una carpeta vacia y ejecutar:

```bash
hugo new site tu_carpeta
```

Ahora que se tiene un sitio de Hugo, que puede activar con este comando:

```bash
hugo serve
```

Esto genera una vista previa local en `localhost:1313` por defecto. Hay que mirar la documentación de hugo ```hugo help``` para ver todas las posibilidades pero yo ejecuto:

```bash
hugo -D serve --ignoreCache --disableFastRender
```

## Creación de su tema personalizado (opcional)

Yo me he basado en un tema ya hecho y con Chrome y la utilidad para ver el código, css, etc. He ido adaptando el tema a lo que quería pero se puede hacer un tema personalizado desde el principio:

Para este paso, recomiendo descargar el [Blank](https://github.com/Vimux/Blank), que es un tema con todos los parciales que necesitará para comenzar (y sin estilos) un punto de partida muy útil. Con este tema se puede construir todo como uno quiera.

### Plantillas con Hugo

Esto es información general. Yo he utilizado algunas cosas. Hay que leer la documentación de Hugo despacio para implementar toda la capacidad del producto. Saber algo de Go es una ventaja muy grande.

Primero [leer la Introducción a las plantillas de Hugo](https://gohugo.io/templates/introduction/) pero intentaré repasar algunos conceptos básicos que ayudarán

Todas las operaciones en Hugo se definen dentro de delimitadores: llaves dobles (p. Ej., `{{.Title}}`), que deberían resultarle familiares si ya has realizado algunas plantillas antes.

Si no lo has hecho, considéralo como una forma de ejecutar operaciones o inyectar valores en un punto específico de su marcado. Para los bloques, terminan con la etiqueta `{{end}}`, para todas las operaciones aparte de los códigos cortos.

Los temas tienen una carpeta de "diseño" que contiene las partes del diseño. La carpeta `_default` será el punto de partida de Hugo, siendo _baseof.html_ La base de tu diseño.

Cada componente, llamados "parciales" (más sobre esto en la documentación de Hugo sobre [Plantilla parcial](https://gohugo.io/templates/partials/)), es similar a cómo usaría `include` en PHP, que es posible que ya lo hayas visto en tu tema de WordPress. Los parciales pueden llamar a otros parciales, pero no lo conviertas en un bucle infinito!

Puedes llamar a un parcial con `{{partial" file.html ". }}`. La sección `parcial` es bastante sencilla, pero las otras dos pueden necesitar una explicación. Habría que tener que escribir _partials/file.html_ pero como todos los parciales deben estar en la carpeta "parcials", Hugo puede encontrar esa carpeta sin problemas. Por supuesto, puede crear subcarpetas dentro de la carpeta "parciales" si necesitas más organización.

El archivo _baseof.html_ es un shell que llama a todos los parciales necesarios para representar el diseño del blog. Debe tener HTML mínimo y muchos parciales:

```html
    <!DOCTYPE html>
    <html lang="{{ .Site.LanguageCode | default "en-us" }}">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>{{ .Title }}</title>
        {{ with .Site.Params.description }}<meta name="description" content="{{ . }}">{{ end }}
        {{ with .Site.Params.author }}<meta name="author" content="{{ . }}">{{ end }}
        <link rel="stylesheet" href="{{ "css/style.css" | relURL }}">
        {{ with .OutputFormats.Get "RSS" -}}
        {{ printf `<link rel="%s" type="%s" href="%s" title="%s">` .Rel .MediaType.Type .RelPermalink $.Site.Title | safeHTML }}
        {{- end }}
    </head>
    <body>
        {{ partial "header" . }}
        {{ block "main" . }}{{ end }}
        {{ partial "footer" . }}
    </body>
    </html>
```

### Hojas de estilo (CSS)

En el tema, hay que crear una carpeta llamada `assets` en la que colocaremos una carpeta`css`. Contendrá nuestros archivos SCSS o un archivo CSS. Ahora, debería haber un archivo _css.html_ en la carpeta `partials` (que es llamado por _head.html_).

## Notas sobre la sintaxis de Hugo

Hay que entender el tema del “punto”, que es la forma en que Hugo analiza las variables (o, concretamente, proporciona una referencia contextual) que hqy que usar en todas las plantillas.

### El punto y el alcance

El punto es como una variable de nivel superior que puede usar en cualquier plantilla o código corto, pero su valor se ajusta a su contexto. El valor del punto en una plantilla de nivel superior como _baseof.html_ es diferente del valor dentro de los bloques de bucle o "con" bloques.

Digamos que esto está en nuestra plantilla en nuestro _head.html_ parcial:

```go
{{with .Site.Title}} {{ . }}{{ end }}
```

Aunque estamos ejecutando esto en el ámbito principal, el valor de Dot cambia según el contexto, que es `.Site.Title` en este caso. Entonces, para imprimir el valor, solo necesitamos escribir `.` en lugar de volver a escribir el nombre de la variable nuevamente. Esto me confundió mucho al principio, pero te acostumbras muy rápido y ayuda a reducir la redundancia ya que solo nombras la variable una vez. Si algo no funciona, normalmente se debe a que estás intentando llamar a una variable de nivel superior dentro de un bloque de ámbito local.

### Condicionales

La sintaxis de los condicionales es un poco diferente de lo que cabría esperar, desde una perspectiva de JavaScript o PHP. En esencia, hay funciones que toman dos argumentos (el paréntesis es opcional si llama a los valores directamente):

```go
{{if eq .Site.LanguageCode "es-es"}} ¡Bienvenido! {{end}}
```

Hay varias de estas funciones:

* [eq](https://gohugo.io/functions/eq/) comprueba la igualdad
* [ne](https://gohugo.io/functions/ne/) comprueba la desigualdad
* [gt](https://gohugo.io/functions/gt/) comprobar si es mayor que
* [ge](https://gohugo.io/functions/ge/) comprobar si es mayor o igual que
* [lt](https://gohugo.io/functions/lt/) comprueba menos de
* [le](https://gohugo.io/functions/le/) comprueba si es menor o igual que

**Nota**: _Puedes conocer todo sobre las funciones que ofrece Hugo en la [Referencia rápida de funciones de Hugo](https://gohugo.io/functions) ._

## Contenido y datos

El contenido se almacena como archivos Markdown, pero también puedes usar HTML. Hugo lo renderizará correctamente al construir el sitio.

La página de inicio llamará al diseño `_default/list.html`

El bloque principal llama al parcial `list.html` con el contexto de` . `, también conocido como el nivel superior.

Cuando se tenga una lista básica de nuestros artículos, que puede diseñar como desee. El número de artículos por página se define en el archivo de configuración, con `paginate = 5` (en TOML).

Una peculiaridad de Hugo es el [formato de fecha](https://gohugo.io/functions/format/). Simplemente hay que poner una especie de "ejemplo" del formato que queremos y él lo adapta a la fecha actual. Fácil de implementar una vez que lo sabes!

## Conclusión

¡Qué viaje migrar de WordPress a Hugo! Me he dejado muchas cosas por el camino. Es imposible escribir todo. Espero que sirva de algo.
A mi me ha servido para mejorar mi sitio en velocidad, contenido y control de mis documentos.

### Recursos adicionales

* [Documentación de Hugo](https://gohugo.io/documentation/)
  * [Instalación](https://gohugo.io/getting-started/installing/)
  * [Inicio rápido](https://gohugo.io/getting-started/quick-start/)
  * [Configuración](https://gohugo.io/getting-started/configuration/)
  * [Plantillas](https://gohugo.io/templates/introduction/)
  * [Taxonomías](https://gohugo.io/content-management/taxonomies/)
  * [Códigos cortos](https://gohugo.io/content-management/shortcodes/)
  * [Hugo en Netlify](https://gohugo.io/hosting-and-deployment/hosting-on-netlify/)
* [Documentación de Netlify](https://www.netlify.com/docs/)
  * [Dominios personalizados](https://www.netlify.com/docs/custom-domains/)
  * [DNS administrado](https://www.netlify.com/docs/dns/)
  * [netlify.toml Deploy Scripts](https://www.netlify.com/docs/netlify-toml-reference/)
* [Documentación de Netlify CMS](https://www.netlifycms.org/docs/intro/)
  * [Widgets](https://www.netlifycms.org/docs/widgets/)
* [Git LFS](https://git-lfs.github.com/)
