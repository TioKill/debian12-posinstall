Script de pós-instalação e Configuração do Debian


Este é um script bash para configurar e instalar várias ferramentas e pacotes no Debian. Ele realiza várias etapas, incluindo a configuração do , verificação da conexão com a internet, atualização do sistema, instalação do sudo, instalação de codecs de áudio e vídeo, instalação de navegadores, Wine, Steam, atualização do firmware do processador e instalação de softwares de edição/produção.sources.list

Requisitos
Debian (testado no Debian 12 'Bookworm')
Modo de Utilização
Abra o terminal como root e execute o script usando o seguinte comando:

bash
Copy code
sudo ./nome_do_script.sh
(O nome padrão do script é "posinstalacao.sh")

Configuração do sources.list
A modificação do arquivo sources.list acima adiciona e configura os repositórios oficiais do Debian 12 'Bookworm'. Esses repositórios são fontes de pacotes de software que podem ser instalados no sistema operacional Debian.

Aqui está uma explicação simplificada do que cada linha alterada representa:

deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware:
Adiciona o repositório principal (main) do Debian 12 'Bookworm', que contém os pacotes oficiais suportados.
O termo  indica que o repositório também inclui pacotes mantidos por terceiros, que dependem dos pacotes principais.contrib
O termo  indica que o repositório inclui pacotes que não são software livre.non-free
O termo  indica que o repositório inclui firmware não livre para dispositivos específicos.non-free-firmware
Essa linha está descomentada, o que significa que ela está ativa e será usada pelo sistema para buscar pacotes.

# deb-src http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware:
Essa linha está comentada (precedida pelo caractere ), o que significa que está inativa.#
Essa linha seria usada caso você precise baixar os arquivos de código-fonte dos pacotes presentes no repositório principal. No entanto, como está comentada, essa funcionalidade está desabilitada.
As demais linhas seguem uma lógica semelhante, adicionando repositórios específicos para atualizações de segurança (bookworm-security), atualizações do sistema (bookworm-updates) e backports (bookworm-backports) que contêm versões mais recentes de alguns pacotes.

Lembrando que a modificação do sources.list permite que você acesse e instale pacotes adicionais no seu sistema Debian, além dos pacotes padrão incluídos na instalação básica.

Alterações e Instalações
O script realiza as seguintes alterações e instalações:

Verifica se está sendo executado como root.
Verifica a conexão com a internet.
Atualiza o sistema.
Instala o sudo e configura para o usuário atual e outros usuários (opcional).
Instala codecs de áudio e vídeo (opcional).
Instala navegadores (Google Chrome, Microsoft Edge, Brave) conforme a escolha do usuário (opcional).
Instala o Wine (opcional).
Atualiza o firmware do processador (opcional).
Instala softwares de edição/produção (Audacity, Blender, GIMP, Inkscape, Kdenlive, Krita, OBS Studio, OpenShot-qt) conforme a escolha do usuário (opcional).
Atenção
Este script realiza alterações no sistema e instalações de pacotes, portanto, execute-o com cuidado e por sua própria conta e risco.
Verifique as opções disponíveis e escolha apenas as que você deseja instalar.
Certifique-se de ter uma conexão estável com a internet antes de executar o script.
