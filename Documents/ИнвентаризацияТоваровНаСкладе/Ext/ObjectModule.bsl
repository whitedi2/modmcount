﻿
&Перед("ПередЗаписью")
Процедура УУ_ПередЗаписью1(Отказ, РежимЗаписи, РежимПроведения)

	Если Модифицированность() Тогда
		Если ДополнительныеСвойства.Свойство("НеДобавлятьЗаписьВРегистрИзмененных") Тогда
			Если Не ДополнительныеСвойства.НеДобавлятьЗаписьВРегистрИзмененных Тогда
				сабОбщегоНазначенияБУХ.УстановитьМодифицированностьБУДокумента(ЭтотОбъект, Ссылка, РежимЗаписи);
			КонецЕсли;
		Иначе
			сабОбщегоНазначенияБУХ.УстановитьМодифицированностьБУДокумента(ЭтотОбъект, Ссылка, РежимЗаписи);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&После("ОбработкаЗаполнения")
Процедура УУ_ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.УЧ_Инвентаризация") Тогда  
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,,"Номер, Проведен");
		//ЭтотОбъект.ВидОперации =  Перечисления.ВидыОперацийСписаниеТоваров.СписаниеСоСклада;
		
		Для каждого ТекСтрока Из ДанныеЗаполнения.Товары Цикл
			
			Если ТекСтрока.Количество <= 0 И ТекСтрока.КоличествоФакт <= 0 Тогда
				Продолжить;			
			КонецЕсли;
			
			НоваяСтрока = ЭтотОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			НоваяСтрока.КоличествоУчет = ТекСтрока.КоличествоБУ;
			НоваяСтрока.СуммаУчет = ТекСтрока.СуммаБУ;
			НоваяСтрока.Количество = ТекСтрока.КоличествоФакт;
			НоваяСтрока.Сумма = ТекСтрока.СуммаФакт;
		КонецЦикла;
		
		НовОбъект = Документы.ИнвентаризацияТоваровНаСкладе.СоздатьДокумент();
		ЗаполнитьЗначенияСвойств(НовОбъект, ДанныеЗаполнения,,"Дата, Номер");
		//НовОбъект.ВидОперации = Перечисления.ВидыОперацийСписаниеТоваров.СписаниеСоСклада;
		
		Для каждого ТекСтрока Из ДанныеЗаполнения.Товары Цикл
			
			//Если ТекСтрока.Количество <= 0 И ТекСтрока.КоличествоФакт <= 0 Тогда
			//	Продолжить;			
			//КонецЕсли;
			
			НоваяСтрока = НовОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			НоваяСтрока.КоличествоУчет = ТекСтрока.КоличествоБУ;
			НоваяСтрока.СуммаУчет = ТекСтрока.СуммаБУ;
			НоваяСтрока.Количество = ТекСтрока.КоличествоФакт;
			НоваяСтрока.Сумма = ТекСтрока.СуммаФакт;
		КонецЦикла;
		
		ЗаполнениеДокументов.Заполнить(НовОбъект, ДанныеЗаполнения, Истина);
		
		ЭтотОбъект.Товары.Очистить();
		
		МассивНоменклатуры = Новый Массив;
		
		Для каждого ТекСтрока Из НовОбъект.Товары Цикл
			НоваяСтрока = ЭтотОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			МассивНоменклатуры.Добавить(НоваяСтрока.Номенклатура);
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры
