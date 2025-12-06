import React, { useState } from 'react';
import './FolderTree.css';

interface FolderItem {
  name: string;
  type: 'folder' | 'file';
  comment?: string;
  children?: FolderItem[];
}

interface FolderTreeProps {
  items: FolderItem[];
  rootName?: string;
  defaultExpanded?: boolean;
}

const FolderTreeItem: React.FC<{
  item: FolderItem;
  level: number;
  isLast: boolean;
  siblings: FolderItem[];
  defaultExpanded?: boolean;
}> = ({ item, level, isLast: _isLast, siblings: _siblings, defaultExpanded = false }) => {
  const [isExpanded, setIsExpanded] = useState(defaultExpanded);
  const hasChildren = item.children && item.children.length > 0;

  const toggleExpanded = () => {
    if (hasChildren) {
      setIsExpanded(!isExpanded);
    }
  };

  return (
    <div className="folder-tree-item" data-level={level}>
      <div
        className={`folder-tree-line ${item.type === 'folder' ? 'folder-tree-clickable' : ''}`}
        onClick={toggleExpanded}
      >
        {hasChildren && <span className="folder-tree-toggle">{isExpanded ? '▼' : '▶'}</span>}
        {!hasChildren && <span className="folder-tree-spacer" />}
        <span
          className={`folder-tree-icon ${item.type === 'folder' ? 'folder-tree-folder-icon' : 'folder-tree-file-icon'}`}
        >
          {item.type === 'folder' ? (
            <svg
              width="16"
              height="16"
              viewBox="0 0 16 16"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                d="M2 3C2 2.44772 2.44772 2 3 2H6.58579C6.851 2 7.10536 2.10536 7.29289 2.29289L8.70711 3.70711C8.89464 3.89464 9.149 4 9.41421 4H13C13.5523 4 14 4.44772 14 5V13C14 13.5523 13.5523 14 13 14H3C2.44772 14 2 13.5523 2 13V3Z"
                fill="currentColor"
              />
            </svg>
          ) : (
            <svg
              width="16"
              height="16"
              viewBox="0 0 16 16"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                d="M4 2C3.44772 2 3 2.44772 3 3V13C3 13.5523 3.44772 14 4 14H12C12.5523 14 13 13.5523 13 13V5.5C13 5.22386 12.7761 5 12.5 5H9C8.44772 5 8 4.55228 8 4V2.5C8 2.22386 7.77614 2 7.5 2H4Z"
                fill="currentColor"
              />
              <path
                d="M9 2V4C9 4.27614 9.22386 4.5 9.5 4.5H12.5"
                stroke="currentColor"
                strokeWidth="1"
                strokeLinecap="round"
              />
            </svg>
          )}
        </span>
        <span
          className={`folder-tree-name ${item.type === 'folder' ? 'folder-tree-folder' : 'folder-tree-file'}`}
        >
          {item.name}
        </span>
        {item.comment && <span className="folder-tree-comment"> {item.comment}</span>}
      </div>
      {hasChildren && isExpanded && item.children && (
        <div className="folder-tree-children">
          {item.children
            .sort((a, b) => {
              // 폴더를 먼저, 파일을 나중에
              if (a.type === 'folder' && b.type === 'file') return -1;
              if (a.type === 'file' && b.type === 'folder') return 1;
              // 같은 타입이면 이름순 정렬
              return a.name.localeCompare(b.name);
            })
            .map((child, index) => (
              <FolderTreeItem
                key={index}
                item={child}
                level={level + 1}
                isLast={index === item.children!.length - 1}
                siblings={item.children!}
                defaultExpanded={defaultExpanded}
              />
            ))}
        </div>
      )}
    </div>
  );
};

export const FolderTree: React.FC<FolderTreeProps> = ({
  items,
  rootName = '',
  defaultExpanded = false,
}) => {
  // 폴더를 먼저, 파일을 나중에 정렬
  const sortedItems = [...items].sort((a, b) => {
    if (a.type === 'folder' && b.type === 'file') return -1;
    if (a.type === 'file' && b.type === 'folder') return 1;
    return a.name.localeCompare(b.name);
  });

  return (
    <div className="folder-tree">
      {rootName && <div className="folder-tree-root">{rootName}/</div>}
      {sortedItems.map((item, index) => (
        <FolderTreeItem
          key={index}
          item={item}
          level={0}
          isLast={index === sortedItems.length - 1}
          siblings={sortedItems}
          defaultExpanded={defaultExpanded}
        />
      ))}
    </div>
  );
};
