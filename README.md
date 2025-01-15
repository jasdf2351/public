Generate a key within a container via:
ssh-keygen -t ed25519 -C ""

Copy the keys:
/root/.ssh/id_ed25519.pub
/root/.ssh/id_ed25519
out of the container
Copy the .pub into GitHub private repo deploy key

To run the container:
docker compose up --build