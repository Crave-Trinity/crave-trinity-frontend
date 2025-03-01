// CravingMapper.swift
internal struct CravingMapper {
    
    func mapToEntity(_ dto: CravingDTO) -> CravingEntity {
        // Now pass the two missing parameters:
        CravingEntity(
            id: dto.id,
            text: dto.text,
            confidenceToResist: dto.confidenceToResist,
            cravingStrength: dto.cravingStrength,
            timestamp: dto.timestamp,
            isArchived: dto.isArchived
        )
    }
    
    func mapToDTO(_ entity: CravingEntity) -> CravingDTO {
        // And supply them here as well:
        CravingDTO(
            id: entity.id,
            text: entity.text,
            confidenceToResist: entity.confidenceToResist,
            cravingStrength: entity.cravingStrength,
            timestamp: entity.timestamp,
            isArchived: entity.isArchived
        )
    }
}
