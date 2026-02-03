# Drive Folder Migration Template

## Purpose
Migrate and rename folders in Google Drive with updated local sync configuration.

## Input Requirements
- Old folder name (local and remote)
- New folder name with icon/copyright
- Sync script location
- Backup verification

## Process

### 1. Backup Current State
- [ ] Verify local folder is clean (git status)
- [ ] Document current sync configuration
- [ ] Create backup of sync script
- [ ] Note last successful sync timestamp

### 2. Create New Drive Folder
```bash
# Create new folder structure in Drive
rclone mkdir "gdrive_suxen:[NEW_FOLDER_NAME]"
```

### 3. Sync Content
```bash
# Initial sync local → new Drive folder
rclone sync [LOCAL_PATH] "gdrive_suxen:[NEW_FOLDER_NAME]" \
  --progress \
  --exclude ".git/**" \
  --dry-run  # Remove --dry-run after verification
```

### 4. Update Sync Scripts
- [ ] Update REMOTE_PATH variable
- [ ] Update script documentation
- [ ] Test sync up/down/status commands
- [ ] Update docs referencing old folder name

### 5. Validation
- [ ] Verify all files synced
- [ ] Test bidirectional sync
- [ ] Check file count matches
- [ ] Confirm git status clean

### 6. Cleanup (Optional)
- [ ] Archive or delete old Drive folder
- [ ] Update documentation references
- [ ] Commit updated sync scripts

## Output
- New Drive folder operational
- Sync scripts updated and tested
- Documentation current
- Old folder archived/removed

∰◊€π¿
